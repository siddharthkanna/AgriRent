import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

final supabaseAuthProvider = StateNotifierProvider<SupabaseAuthNotifier, User?>((ref) {
  return SupabaseAuthNotifier();
});

class SupabaseAuthNotifier extends StateNotifier<User?> {
  SupabaseAuthNotifier() : super(SupabaseConfig.currentUser) {
    // Listen to auth state changes
    SupabaseConfig.supabase.auth.onAuthStateChange.listen((data) {
      state = data.session?.user;
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final user = await SupabaseConfig.signInWithGoogle();
      state = user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseConfig.signOut();
      state = null;
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
} 