import 'package:dermai/firebase_options.dart';
import 'package:dermai/google_sign_in_provider.dart';
import 'package:dermai/main_pages/bottom_nav_bar.dart';
import 'package:dermai/sign_in.dart';
import 'package:dermai/demo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
      ],
      child: const DermAIApp(),
    ),
  );
}

class DermAIApp extends StatelessWidget {
  const DermAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      home: const _AuthGate(),
    );
  }
}

/// Decides the first screen based on auth state:
///   - Never logged in  →  Onboarding
///   - Logged out       →  Sign In
///   - Logged in        →  BottomNavBar
class _AuthGate extends StatelessWidget {
  const _AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF1DC25F)),
            ),
          );
        }

        // Authenticated → main app
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNavBar();
        }

        // Not authenticated → onboarding (first launch) or sign-in
        return const _OnboardingOrSignIn();
      },
    );
  }
}

/// Shows onboarding once then lands on sign-in.
/// We use a simple bool tracked in memory (no persistence needed —
/// onboarding auto-routes to sign-in via its own Skip/Next buttons).
class _OnboardingOrSignIn extends StatefulWidget {
  const _OnboardingOrSignIn({Key? key}) : super(key: key);

  @override
  State<_OnboardingOrSignIn> createState() => _OnboardingOrSignInState();
}

class _OnboardingOrSignInState extends State<_OnboardingOrSignIn> {
  bool _showOnboarding = true;

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      // DemoPage internally navigates to BottomNavBar on Skip.
      // We wrap it so after that push we stay in the auth gate flow.
      return DemoPage(
        onDone: () => setState(() => _showOnboarding = false),
      );
    }
    return const SignIn();
  }
}
