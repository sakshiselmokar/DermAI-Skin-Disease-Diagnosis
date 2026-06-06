import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dermai/resources.dart';
import 'package:dermai/services/tflite_service.dart';
import 'package:dermai/screens/deep_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final SkinDiagnosisResult result;

  const ResultScreen({Key? key, required this.image, required this.result})
      : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;
  bool _saving = false;

  static const Map<String, String> _info = {
    'Acne and Rosacea':
        'Characterised by pimples, redness and skin inflammation. Consult a dermatologist for topical or oral treatment options.',
    'Eczema':
        'A chronic condition causing itchy, inflamed skin. Moisturisers and corticosteroid creams are common first-line treatments.',
    'Melanoma Skin Cancer Nevi and Moles':
        'Irregular moles or dark patches may indicate melanoma. Seek urgent medical attention for professional evaluation.',
    'Nail Fungus and other Nail Disease':
        'Fungal nail infections cause thickening and discolouration. Antifungal medication (oral or topical) is usually effective.',
    'Psoriasis pictures Lichen Planus and related diseases':
        'Causes red, scaly patches on the skin. Various topical treatments and lifestyle adjustments can help manage symptoms.',
  };

  static const Map<String, String> _diseaseMap = {
    'acne': 'Acne & Rosacea',
    'rosacea': 'Acne & Rosacea',
    'eczema': 'Eczema',
    'melanoma': 'Melanoma / Moles',
    'nevi': 'Melanoma / Moles',
    'moles': 'Melanoma / Moles',
    'nail': 'Nail Fungus',
    'fungus': 'Nail Fungus',
    'psoriasis': 'Psoriasis',
    'lichen': 'Psoriasis',
  };

  String get _guidance {
    for (final key in _info.keys) {
      if (widget.result.label
          .toLowerCase()
          .contains(key.split(' ').first.toLowerCase())) {
        return _info[key]!;
      }
    }
    return 'Please consult a qualified dermatologist for a professional diagnosis and treatment plan.';
  }

  String? get _matchedDisease {
    final lower = widget.result.label.toLowerCase();
    for (final key in _diseaseMap.keys) {
      if (lower.contains(key)) return _diseaseMap[key];
    }
    return null;
  }

  Color _confidenceColor(double conf) {
    if (conf >= 0.7) return Colors.green.shade600;
    if (conf >= 0.45) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  Future<void> _saveToHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('scan_history')
          .add({
        'label': widget.result.label,
        'confidence': widget.result.confidence,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() { _saved = true; _saving = false; });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Scan saved to history!'),
        backgroundColor: c,
        behavior: SnackBarBehavior.floating,
      ));
    } catch (_) {
      setState(() => _saving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to save. Please try again.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _goTo(BuildContext context, int tab) {
    DeepLink.disease = _matchedDisease;
    Navigator.of(context).popUntil((r) => r.isFirst);
    BottomNavController.switchTo?.call(tab);
  }

  @override
  Widget build(BuildContext context) {
    final disease = _matchedDisease;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Diagnosis Result',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        actions: [
          if (!_saved)
            IconButton(
              icon: _saving
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: c))
                  : const Icon(Icons.bookmark_border_rounded, color: Colors.black54),
              tooltip: 'Save to history',
              onPressed: _saving ? null : _saveToHistory,
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.bookmark_rounded, color: c),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(widget.image, height: 240, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),

            // Result card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7FFF9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.withOpacity(0.3)),
                boxShadow: [BoxShadow(color: c.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.biotech_rounded, color: c, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text('AI Prediction',
                        style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                  ]),
                  const SizedBox(height: 14),
                  Text(widget.result.label,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  Row(children: [
                    const Text('Confidence', style: TextStyle(fontSize: 13, color: Colors.black54)),
                    const Spacer(),
                    Text(widget.result.confidencePercent,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                            color: _confidenceColor(widget.result.confidence))),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: widget.result.confidence.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(_confidenceColor(widget.result.confidence)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Guidance card
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('What this means',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                  ]),
                  const SizedBox(height: 10),
                  Text(_guidance,
                      style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Deep-link buttons (only if disease matched)
            if (disease != null) ...[
              Row(children: [
                Expanded(child: _linkButton(
                  icon: Icons.spa_outlined, label: 'Skincare Tips',
                  sublabel: disease, onTap: () => _goTo(context, 1),
                )),
                const SizedBox(width: 12),
                Expanded(child: _linkButton(
                  icon: Icons.eco_outlined, label: 'Home Remedies',
                  sublabel: disease, onTap: () => _goTo(context, 2),
                )),
              ]),
              const SizedBox(height: 16),
            ],

            // Disclaimer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(child: Text(
                    'This is an AI estimate only (~60% accuracy). Always consult a certified dermatologist before taking any medical action.',
                    style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Save / Saved button
            if (!_saved)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: c, side: const BorderSide(color: c),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: _saving
                    ? const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: c))
                    : const Icon(Icons.bookmark_border_rounded),
                label: Text(_saving ? 'Saving...' : 'Save to History',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                onPressed: _saving ? null : _saveToHistory,
              )
            else
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.withOpacity(0.3)),
                ),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.check_circle_rounded, color: c),
                  SizedBox(width: 8),
                  Text('Saved to History',
                      style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w600)),
                ]),
              ),
            const SizedBox(height: 12),

            // Scan again
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: c, foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Scan Another Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _linkButton({
    required IconData icon, required String label,
    required String sublabel, required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FFF6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withOpacity(0.25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: c, size: 22),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 2),
          Text(sublabel, style: const TextStyle(fontSize: 11, color: c),
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}
