// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/supabase_config.dart';
import '../models/user.model.dart' as UserModel;

final authProvider = StateNotifierProvider<AuthNotifier, UserModel.User?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<UserModel.User?> {
  AuthNotifier() : super(null);

  void updateUserState(Map<String, dynamic> userData) {
    print('Updating auth state with user data: $userData');
    try {
      final user = UserModel.User.fromJson(userData);
      print('Created user object: ${user.id}, ${user.name}, ${user.email}');
      state = user;
      print('State updated. Current user ID: ${state?.id}');
    } catch (e) {
      print('Error updating user state: $e');
      state = null;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await SupabaseConfig.signInWithGoogle();
    } catch (error) {
      print("Error signing in with Google: $error");
      throw error;
    }
  }

  Future<void> signOut() async {
    try {
      state = null;
      await SupabaseConfig.signOut();
    } catch (e) {
      print('Failed to sign out. Please try again.: $e');
      throw e;
    }
  }
}
