// ignore_for_file: prefer_const_constructors

import 'package:agrirent/screens/LanguageSelection.dart';
import 'package:flutter/material.dart';
import 'package:agrirent/pages/profile/RentingHistory/RentalHistory.dart';
import 'package:agrirent/pages/profile/PostingHistory/PostingHistory.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/screens/auth.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
        actions: [
          IconButton(
            onPressed: () {
              // _showLanguageDialog(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguageSelectionScreen()),
              );
            },
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
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
        _buildOption('Profile Settings'),
        _buildOption('Renting History'),
        _buildOption('Posting History'),
        _buildOption('Your Bookmarks'),
      ],
    );
  }

  Widget _buildOption(String optionText) {
    return GestureDetector(
      onTap: () {
        if (optionText == 'Renting History') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RentalHistoryPage()),
          );
        } else if (optionText == 'Posting History') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostingHistoryPage()),
          );
        } else {
          // Handle other options
        }
      },
      child: Container(
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
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
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
