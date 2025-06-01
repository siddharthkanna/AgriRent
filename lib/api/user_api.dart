import 'package:agrirent/config/dio.dart';
import 'package:agrirent/config/url.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/screens/pageview.dart';
import 'package:flutter/material.dart';
import '../models/user.model.dart';
import '../config/supabase_config.dart';

class UserApi {
  Future<void> signIn(BuildContext context, AuthNotifier auth) async {
    try {
      print('Starting sign in process...');
      
      // Get Google auth data through Supabase
      final supabaseUser = await SupabaseConfig.signInWithGoogle();
      if (supabaseUser == null) {
        throw Exception('Google authentication failed');
      }
      
      print('Google auth completed. Email: ${supabaseUser.email}');

      // Send auth data to backend
      final response = await dio.post(
        loginUrl,
        data: {
          'email': supabaseUser.email,
          'name': supabaseUser.userMetadata?['full_name'],
          'photoUrl': supabaseUser.userMetadata?['avatar_url'],
        },
      );

      print('Backend response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data['user'];
        if (userData == null) {
          throw Exception('No user data in response');
        }

        // Update state with backend user data
        auth.updateUserState(userData);
        
        // Navigate to main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageViewScreen(),
          ),
        );
      } else {
        throw Exception('Failed to sign in: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error in sign in: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final response = await dio.get('$userUrl/$userId');

      if (response.statusCode == 200) {
        final userData = response.data['user'] ?? response.data;
        return userData;
      } else {
        throw Exception('Failed to fetch user data: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to fetch user data: $e');
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> userData) async {
    try {
      final response = await dio.put(
        '$userUrl/$userId',
        data: userData,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user data: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error updating user data: $e');
      throw Exception('Failed to update user data: $e');
    }
  }
}
