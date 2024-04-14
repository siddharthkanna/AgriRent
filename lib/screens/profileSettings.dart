// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);
    final userDetails = authNotifier.userDetails;

    TextEditingController _nameController = TextEditingController();
    TextEditingController _mobileController = TextEditingController();
    String _email = userDetails?.email ?? '';

    // Fetch user's profile data
    _nameController.text = userDetails?.displayName ?? '';
    _mobileController.text = userDetails?.mobileNumber ?? '';

    void updateProfile() {
      // Implement updating user's profile data with the values in the text fields
      String name = _nameController.text;
      String mobile = _mobileController.text;
      // Send updated profile data to your backend or update locally
      // Handle success and error cases
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: updateProfile,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Mobile Number'),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter your mobile number',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Email'),
            // Display non-editable email
            Text(_email),
          ],
        ),
      ),
    );
  }
}
