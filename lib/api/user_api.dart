import 'package:agrirent/config/dio.dart';
import 'package:agrirent/config/url.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/screens/pageview.dart';
import 'package:flutter/material.dart';
import '../models/user.model.dart';

class UserApi {
  Future<void> signIn(BuildContext context, AuthNotifier auth) async {
    try {
      await auth.signInWithGoogle(context);
      final user = auth.user;

      if (user != null) {
        final userData = User(
          displayName: user.displayName ?? '',
          email: user.email ?? '',
          googleId: user.uid,
          photoURL: user.photoURL ?? '',
          mobileNumber: user.phoneNumber ?? '',
        );
        final userDataJson = userData.toJson();
        final response = await dio.post(
          loginUrl,
          data: userDataJson,
        );
        print("User email: ${auth.user?.email}");
        print(response.data);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PageViewScreen(),
          ),
        );
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final response = await dio.get(
        '$getUserDataUrl/$userId',
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print("Error fetching user data: $e");
      throw Exception('Failed to load user data');
    }
  }
}
