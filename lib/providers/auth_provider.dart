// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user.model.dart' as UserModel;

final authProvider = Provider((ref) => AuthNotifier());

class AuthNotifier {
  final _supabase = SupabaseConfig.supabase;

  User? get user => _supabase.auth.currentUser;
  String? get userId => user?.id;

  UserModel.User? get userDetails {
    if (user != null) {
      return UserModel.User(
        displayName: user!.userMetadata?['full_name'] ?? "",
        email: user!.email ?? "",
        googleId: user!.id,
        photoURL: user!.userMetadata?['avatar_url'] ?? "",
        mobileNumber: user!.phone ?? "",
      );
    }
    return null;
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
      await SupabaseConfig.signOut();
    } catch (e) {
      print('Failed to sign out. Please try again.: $e');
      throw e;
    }
  }
}
