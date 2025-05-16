import 'package:agrirent/config/dio.dart';
import 'package:agrirent/config/url.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/screens/pageview.dart';
import 'package:flutter/material.dart';
import '../models/user.model.dart';

class UserApi {
  Future<void> signIn(BuildContext context, AuthNotifier auth) async {
    try {
      print("Starting Google sign-in process");
      await auth.signInWithGoogle(context);
      final user = auth.user;
      print("User: ${user?.email}");
      print("Google sign-in completed. User: ${user?.id}");

      if (user != null) {
        print("Creating User object with metadata");
        final userData = User(
          displayName: user.userMetadata?['full_name'] ?? '',
          email: user.email ?? '',
          googleId: user.id,
          photoURL: user.userMetadata?['avatar_url'] ?? '',
          mobileNumber: user.phone ?? '',
        );
        final userDataJson = userData.toJson();
        print("User data prepared: $userDataJson");

        print("Sending POST request to $loginUrl");
        final response = await dio.post(
          loginUrl,
          data: userDataJson,
        );
        print("User email: ${auth.user?.email}");
        print("Server response: ${response.data}");

        print("Navigating to PageViewScreen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageViewScreen(),
          ),
        );
      } else {
        print("User is null after Google sign-in");
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
      print("Stack trace: ${StackTrace.current}");
      throw e;
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
