import 'package:dermai/main_pages/home.dart';
import 'package:dermai/main_pages/skincare_screen.dart';
import 'package:dermai/main_pages/home_remedies_screen.dart';
import 'package:dermai/main_pages/profile.dart';
import 'package:dermai/resources.dart';
import 'package:dermai/screens/chatbot_screen.dart';
import 'package:dermai/screens/deep_link.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    BottomNavController.switchTo = (int index) {
      if (mounted) setState(() => _currentIndex = index);
    };
  }

  @override
  void dispose() {
    BottomNavController.switchTo = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skincareDisease = _currentIndex == 1 ? DeepLink.disease : null;
    final remediesDisease = _currentIndex == 2 ? DeepLink.disease : null;

    final pages = [
      const HomeScreen(),
      SkincareScreen(initialDisease: skincareDisease),
      HomeRemediesScreen(initialDisease: remediesDisease),
      const ChatbotScreen(),
      const Profile(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            if (i != 1 && i != 2) DeepLink.disease = null;
            setState(() => _currentIndex = i);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: c,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined),
              activeIcon: Icon(Icons.document_scanner_rounded),
              label: 'Diagnose',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa_outlined),
              activeIcon: Icon(Icons.spa_rounded),
              label: 'Skincare',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.eco_outlined),
              activeIcon: Icon(Icons.eco_rounded),
              label: 'Remedies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              activeIcon: Icon(Icons.smart_toy_rounded),
              label: 'AI Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
