import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                profilePicture(),
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

  Widget profilePicture() {
    return const CircleAvatar(
      radius: 50.0,
      backgroundImage: NetworkImage(
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      ),
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
        onPressed: () {
          // Handle sign-out action
        },
        child: const Text(
          'Sign Out',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
