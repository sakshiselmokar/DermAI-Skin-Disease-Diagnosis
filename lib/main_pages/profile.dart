import 'package:dermai/edit_profile.dart';
import 'package:dermai/resources.dart';
import 'package:dermai/screens/scan_history_screen.dart';
import 'package:dermai/screens/nearby_doctors_screen.dart';
import 'package:dermai/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? user?.email?.split('@').first ?? 'User';
    final email = user?.email ?? '';
    final photoUrl = user?.photoURL;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          child: Column(children: [
            // Avatar
            Stack(alignment: Alignment.bottomRight, children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: c.withOpacity(0.15),
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null ? Icon(Icons.person_rounded, size: 52, color: c) : null,
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfile())),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(email, style: const TextStyle(fontSize: 13, color: Colors.black45)),
            const SizedBox(height: 32),

            _tile(context, Icons.person_outline_rounded, 'Edit Profile', () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfile()))),
            _tile(context, Icons.history_rounded, 'Scan History', () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanHistoryScreen()))),
            _tile(context, Icons.location_on_outlined, 'Find Nearby Dermatologists', () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyDoctorsScreen()))),
            _tile(context, Icons.help_outline_rounded, 'Help & FAQ', () => _showHelp(context)),
            _tile(context, Icons.privacy_tip_outlined, 'Privacy Policy', () => _showPrivacy(context)),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            _tile(context, Icons.logout_rounded, 'Sign Out', () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => const SignIn()), (r) => false);
            }, color: Colors.redAccent),
          ]),
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Help & FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _faqItem('How accurate is the AI?',
              'The model has ~60% accuracy. It is a screening tool only — always consult a dermatologist.'),
          _faqItem('How do I get the best results?',
              'Use good lighting, focus on the affected area, and avoid blurry images.'),
          _faqItem('Is my data private?',
              'Your scans are saved only to your personal Firestore account and are never shared.'),
          _faqItem('Which diseases can it detect?',
              'Acne & Rosacea, Eczema, Melanoma/Moles, Nail Fungus, and Psoriasis.'),
          _faqItem('Can I delete my scan history?',
              'Yes — swipe left on any scan in History to delete it.'),
        ]),
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Privacy Policy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(
            'DermAI collects only your email address and scan results to provide personalised features. '
            'We do not sell or share your data with any third parties. '
            'All data is stored securely in Google Firebase.\n\n'
            'Images you scan are processed on-device and are never uploaded to any server. '
            'You can delete your scan history at any time from the History screen.',
            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.6),
          ),
        ]),
      ),
    );
  }

  Widget _faqItem(String q, String a) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(q, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
      const SizedBox(height: 4),
      Text(a, style: const TextStyle(fontSize: 12, color: Colors.black45, height: 1.5)),
    ]),
  );

  Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: (color ?? c).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 20, color: color ?? c),
      ),
      title: Text(label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color ?? Colors.black87)),
      trailing: color == null ? const Icon(Icons.chevron_right_rounded, color: Colors.black38) : null,
      onTap: onTap,
    );
  }
}
