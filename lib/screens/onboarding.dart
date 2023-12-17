import 'package:agrirent/screens/auth.dart';
import 'package:flutter/material.dart';
import '../theme/palette.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Title at the top center
          Container(
            alignment: Alignment.topCenter,
            child: const Text(
              'AgriRent',
              style: TextStyle(
                fontSize: 52.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          // Image in the middle
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/farmer_onboarding.jpg',
              width: 350.0,
              height: 350.0,
            ),
          ),
          const SizedBox(height: 30.0),

          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Palette.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
