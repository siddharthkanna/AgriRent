import 'package:agrirent/firebase_options.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './screens/onboarding.dart';
import './screens/pageview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'poppins',
        scaffoldBackgroundColor: Palette.white,
      ),
      home: SafeArea(
        child: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if the user is signed in
    final user = ref.watch(authProvider).user;

    // Return either OnboardingScreen or PageViewScreen based on user authentication
    return user != null ? const PageViewScreen() : OnboardingScreen();
  }
}
