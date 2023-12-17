import 'package:flutter/material.dart';
import 'package:agrirent/screens/pageview.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Your app logo or image here
            // Image.asset('assets/app_logo.png', height: 100, width: 100),

            // Sign Up with Phone Number button
            ElevatedButton(
              onPressed: () {
                // Navigate to phone number sign-up screen
                Navigator.pushNamed(context, '/phone_signup');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                backgroundColor: Colors.blue, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Sign Up with Phone Number',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            SizedBox(height: 20), // Spacer

            // OR Text
            Text(
              'OR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 20), // Spacer

            // Sign Up with Google button
            ElevatedButton.icon(
              onPressed: () {
                // Implement Google Sign-In logic here
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PageViewScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                primary: Colors.red, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              icon: Icon(Icons.login), // Add Google icon
              label: Text(
                'Sign Up with Google',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
