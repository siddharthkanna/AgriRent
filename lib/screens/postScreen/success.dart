import 'package:agrirent/screens/pageview.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/success.json',
              width: 300,
              height: 300,
              repeat: true,
              frameRate: const FrameRate(60),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Equipment Posted Successfully!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PageViewScreen(),
                  ),
                );
              },
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Palette.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
