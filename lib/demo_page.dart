import 'dart:async';
import 'package:dermai/main_pages/bottom_nav_bar.dart';
import 'package:dermai/resources.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  final VoidCallback? onDone;
  const DemoPage({Key? key, this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: GettingStartedScreen(onDone: onDone),
    );
  }
}

class GettingStartedScreen extends StatefulWidget {
  final VoidCallback? onDone;
  const GettingStartedScreen({Key? key, this.onDone}) : super(key: key);

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _finish(BuildContext context) {
    if (widget.onDone != null) {
      widget.onDone!();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const BottomNavBar()));
    }
  }

  static const _slides = [
    _Slide(
      emoji: '🔬',
      title: 'AI Skin Diagnosis',
      description:
          'Upload a photo of any skin condition and DermAI\'s machine learning model identifies it in seconds — powered by a ResNet-50 model trained on thousands of dermatology images.',
      color: Color(0xFFF0FFF6),
      accent: c,
    ),
    _Slide(
      emoji: '🌿',
      title: 'Natural Remedies & Skincare',
      description:
          'Get personalised skincare routines, home remedies using kitchen ingredients, and disease-specific tips — all tailored to your diagnosis.',
      color: Color(0xFFF0FFF6),
      accent: c,
    ),
    _Slide(
      emoji: '📍',
      title: 'Find Nearby Dermatologists',
      description:
          'Locate certified skin specialists near you on Google Maps. DermAI is a screening tool — always follow up with a professional for treatment.',
      color: Color(0xFFF0FFF6),
      accent: c,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          // Logo header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.biotech_rounded, color: c, size: 24),
              ),
              const SizedBox(width: 10),
              const Text('DermAI',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            ]),
          ),

          // PageView
          Expanded(
            child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideItem(slide: _slides[i]),
              ),
              // Dots
              Positioned(
                bottom: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_slides.length, (i) => _Dot(active: i == _currentPage)),
                ),
              ),
            ]),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () => _finish(context),
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Get Started' : 'Skip',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: _currentPage > 0
                      ? () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300), curve: Curves.easeIn)
                      : null,
                  child: Text('Back',
                      style: TextStyle(
                          fontSize: 15,
                          color: _currentPage > 0 ? Colors.black54 : Colors.transparent)),
                ),
                TextButton(
                  onPressed: _currentPage < _slides.length - 1
                      ? () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 300), curve: Curves.easeIn)
                      : () => _finish(context),
                  child: Text(
                    _currentPage < _slides.length - 1 ? 'Next →' : 'Start',
                    style: const TextStyle(fontSize: 15, color: c, fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Slide {
  final String emoji;
  final String title;
  final String description;
  final Color color;
  final Color accent;
  const _Slide({
    required this.emoji, required this.title,
    required this.description, required this.color, required this.accent,
  });
}

class _SlideItem extends StatelessWidget {
  final _Slide slide;
  const _SlideItem({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 60),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Emoji illustration
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: slide.color,
            shape: BoxShape.circle,
            border: Border.all(color: slide.accent.withOpacity(0.2), width: 2),
          ),
          child: Center(child: Text(slide.emoji, style: const TextStyle(fontSize: 72))),
        ),
        const SizedBox(height: 40),
        Text(slide.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: slide.accent)),
        const SizedBox(height: 16),
        Text(slide.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black45, height: 1.7)),
      ]),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: active ? 10 : 7,
      width: active ? 24 : 7,
      decoration: BoxDecoration(
        color: active ? c : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
