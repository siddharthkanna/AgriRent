// ignore_for_file: use_build_context_synchronously
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/screens/auth.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider);
    final User? user = authNotifier.user;
    String dp = user?.photoURL ?? '';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 6, top: 6),
          child: Text(
            'Your Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60.0),
                profilePicture(dp),
                const SizedBox(height: 20.0),
                options(),
                const SizedBox(height: 20.0),
                signOutButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget profilePicture(String dp) {
    return CircleAvatar(
      radius: 50.0,
      backgroundImage: NetworkImage(dp),
    );
  }

  Widget options() {
    return Column(
      children: [
        _buildOption('Your Orders'),
        _buildOption('Your Returns'),
        _buildOption('Payment Options'),
        _buildOption('Account Settings'),
      ],
    );
  }

  Widget _buildOption(String optionText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Palette.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              optionText,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
        onTap: () {
          // Handle option tap
        },
      ),
    );
  }

  Widget signOutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextButton(
        onPressed: () async {
          final authNotifier = ref.read(authProvider);
          await authNotifier.signOut();
          // Navigate to SignUpScreen on successful sign-out
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        },
        child: const Text(
          'Sign Out',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
