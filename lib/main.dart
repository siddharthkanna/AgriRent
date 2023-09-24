import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import './screens/onboarding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'poppins', scaffoldBackgroundColor: Palette.white),
      home: OnboardingScreen(),
    );
  }
}
