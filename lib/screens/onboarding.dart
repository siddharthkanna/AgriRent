import 'package:flutter/material.dart';

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
                fontSize: 42.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          // Image in the middle
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/farmer_onboarding.png',
              width: 200.0,
              height: 200.0,
            ),
          ),
          const SizedBox(height: 30.0),

          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 250, // Make the button take the full width
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add your Sign-In with Google logic here
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.blue, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text('Sign In with Google'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
