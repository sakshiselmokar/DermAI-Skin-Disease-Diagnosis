import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Result returned from the inference pipeline.
class SkinDiagnosisResult {
  final String label;
  final double confidence;

  const SkinDiagnosisResult({
    required this.label,
    required this.confidence,
  });

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(1)}%';
}

/// Singleton service that loads the TFLite model once and runs
/// inference on demand.  All heavy work happens on an isolate via
/// tflite_flutter's built-in interpreter.
class TFLiteService {
  // ── singleton ────────────────────────────────────────────────────────────
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  // ── internals ────────────────────────────────────────────────────────────
  Interpreter? _interpreter;
  List<String> _labels = [];

  static const String _modelPath  = 'assets/skin_quant_model.tflite';
  static const String _labelsPath = 'assets/labels.txt';

  /// Input size expected by the ResNet-50 model.
  static const int _inputSize = 224;

  // ── lifecycle ────────────────────────────────────────────────────────────

  /// Call once (e.g. in main.dart or before first use).
  Future<void> init() async {
    await _loadLabels();
    await _loadModel();
  }

  Future<void> _loadLabels() async {
    final raw = await rootBundle.loadString(_labelsPath);
    _labels = raw
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
  }

  Future<void> _loadModel() async {
    final options = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset(
      _modelPath,
      options: options,
    );
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }

  // ── inference ─────────────────────────────────────────────────────────────

  /// Run inference on [imageFile].
  /// Returns the top prediction or null if something goes wrong.
  Future<SkinDiagnosisResult?> predict(File imageFile) async {
    try {
      if (_interpreter == null) await init();

      // 1. Decode image
      final bytes = await imageFile.readAsBytes();
      img.Image? rawImage = img.decodeImage(bytes);
      if (rawImage == null) throw Exception('Could not decode image');

      // 2. Resize to 224×224
      final resized = img.copyResize(
        rawImage,
        width: _inputSize,
        height: _inputSize,
        interpolation: img.Interpolation.linear,
      );

      // 3. Normalise to [-1, 1]  (standard MobileNet/ResNet preprocessing)
      //    Input tensor shape: [1, 224, 224, 3]  dtype: float32
      final inputTensor = _imageToTensor(resized);

      // 4. Prepare output buffer  [1, numClasses]
      final numClasses = _labels.length;
      final outputBuffer =
          List.filled(numClasses, 0.0).reshape([1, numClasses]);

      // 5. Run
      _interpreter!.run(inputTensor, outputBuffer);

      // 6. Pick top class
      final scores = List<double>.from(outputBuffer[0] as List);
      final topIndex = _argmax(scores);

      return SkinDiagnosisResult(
        label: topIndex < _labels.length ? _labels[topIndex] : 'Unknown',
        confidence: scores[topIndex],
      );
    } catch (e) {
      // Surface in debug; swallow in release and return null so the UI
      // can show a friendly error instead of crashing.
      assert(() {
        // ignore: avoid_print
        print('[TFLiteService] predict error: $e');
        return true;
      }());
      return null;
    }
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  /// Convert an [img.Image] to a float32 tensor [1, H, W, 3] normalised
  /// to [-1, 1] using the standard formula: pixel / 127.5 - 1.0
  List<List<List<List<double>>>> _imageToTensor(img.Image image) {
    return List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            final pixel = image.getPixel(x, y);
            return [
              (pixel.r.toDouble() / 127.5) - 1.0,
              (pixel.g.toDouble() / 127.5) - 1.0,
              (pixel.b.toDouble() / 127.5) - 1.0,
            ];
          },
        ),
      ),
    );
  }

  int _argmax(List<double> values) {
    int best = 0;
    for (int i = 1; i < values.length; i++) {
      if (values[i] > values[best]) best = i;
    }
    return best;
  }

  bool get isReady => _interpreter != null && _labels.isNotEmpty;
}
