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
}
