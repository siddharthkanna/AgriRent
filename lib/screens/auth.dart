import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrirent/api/user_api.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider);
    return Scaffold(
      backgroundColor: Palette.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to AgriRent',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              const FeatureCard(
                title: 'Rent Equipment',
                subtitle: 'Find the right equipment for your farm',
              ),
              const FeatureCard(
                title: 'Post Equipment',
                subtitle: 'List your equipment for other farmers to rent',
              ),
              const FeatureCard(
                title: 'Explore',
                subtitle: 'Discover available equipment for rent near you',
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: UserApi().signIn(context, auth),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          await UserApi().signIn(context, auth);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.g_mobiledata_sharp,
                                color: Palette.white, size: 30), 
                            SizedBox(
                                width: 10), // Add spacing between icon and text
                            Text(
                              'Sign in with Google',
                              style: TextStyle(color: Palette.white, fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const FeatureCard({
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
