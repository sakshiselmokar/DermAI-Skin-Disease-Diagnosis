import 'dart:io';

import 'package:dermai/resources.dart';
import 'package:dermai/screens/result_screen.dart';
import 'package:dermai/services/tflite_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TFLiteService _tflite = TFLiteService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Warm up the model in background so first inference is fast.
    _tflite.init();
  }

  // ── image picking ─────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (picked == null) return;

      setState(() {
        _selectedImage = File(picked.path);
      });
    } catch (e) {
      _showError('Could not pick image. Please try again.');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8FFF1),
                child: Icon(Icons.camera_alt_rounded, color: c),
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8FFF1),
                child: Icon(Icons.photo_library_rounded, color: c),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── inference ─────────────────────────────────────────────────────────────

  Future<void> _runDiagnosis() async {
    if (_selectedImage == null) {
      _showError('Please select an image first.');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _tflite.predict(_selectedImage!);

    setState(() => _isLoading = false);

    if (result == null) {
      _showError('Diagnosis failed. Please try a clearer image.');
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          image: _selectedImage!,
          result: result,
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Image.asset('assets/logo2.png', height: 36),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DermAI',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Skin Disease Diagnosis',
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Hero upload zone
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    color: _selectedImage == null
                        ? const Color(0xFFF4FFF8)
                        : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedImage == null
                          ? c.withOpacity(0.3)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: _selectedImage == null
                      ? _buildUploadPlaceholder()
                      : _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 10),

              if (_selectedImage != null)
                TextButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.refresh_rounded, size: 16, color: c),
                  label: const Text(
                    'Change image',
                    style: TextStyle(color: c, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 24),

              // Tips
              if (_selectedImage == null) _buildTips(),

              const SizedBox(height: 24),

              // CTA button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: c.withOpacity(0.4),
                  ),
                  onPressed: (_isLoading || _selectedImage == null)
                      ? null
                      : _runDiagnosis,
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Diagnose Skin Condition',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/upload_img.png',
          height: 90,
          errorBuilder: (_, __, ___) => Icon(
            Icons.add_a_photo_outlined,
            size: 64,
            color: c.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap to upload a skin image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Camera or Gallery',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 260,
      ),
    );
  }

  Widget _buildTips() {
  final List<Map<String, dynamic>> tips = [
    {
      'text': 'Good lighting',
      'icon': Icons.wb_sunny_outlined,
    },
    {
      'text': 'Focus on affected area',
      'icon': Icons.center_focus_strong_outlined,
    },
    {
      'text': 'Avoid blurry photos',
      'icon': Icons.blur_off_outlined,
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'For best results',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 10),

      ...tips.map(
        (t) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FFF1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  t['icon'],
                  size: 16,
                  color: c,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                t['text'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ).toList(),
    ],
  );
}
}