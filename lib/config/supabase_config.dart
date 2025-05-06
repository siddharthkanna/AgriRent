import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static late final String supabaseUrl;
  static late final String supabaseAnonKey;
  
  static final supabase = Supabase.instance.client;
  static final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? '',
  );
  
  static Future<void> initialize() async {
    print('Initializing SupabaseConfig...');
    // Load values from .env file
    supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    var googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    
    // Print all env values
    dotenv.env.forEach((key, value) {
      print('Environment variable - $key: $value');
    });
    
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty || googleClientId.isEmpty) {
      print('Error: Missing environment variables');
      throw Exception('Supabase URL or Anon Key or Google Client ID not found in environment variables');
    }

    print('Initializing Supabase...');
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true // Enable debug mode to see what's happening
    );
    print('Supabase initialized successfully');
  }
  
  static Future<User?> signInWithGoogle() async {
    print('Attempting to sign in with Google...');
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign In was cancelled by user');
        return null;
      }

      print('Google Sign In successful. Getting auth details...');
      // Get auth details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        print('Error: No ID Token found');
        throw Exception('No ID Token found');
      }

      print('Creating Supabase credentials...');
      // Create Supabase credentials
      final AuthResponse res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (res.user == null) {
        print('Error: No user returned from Supabase');
        throw Exception('No user returned from Supabase');
      }

      print('Sign in with Google successful');
      return res.user;
    } catch (e) {
      print('Detailed sign in error: $e');
      throw Exception('Failed to sign in with Google: $e');
    }
  }
  
  static Future<void> signOut() async {
    print('Attempting to sign out...');
    try {
      await Future.wait([
        supabase.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      print('Sign out successful');
    } catch (e) {
      print('Error during sign out: $e');
      throw e;
    }
  }
  
  static bool get isAuthenticated {
    final isAuth = supabase.auth.currentUser != null;
    print('Checking authentication status: $isAuth');
    return isAuth;
  }
  
  static User? get currentUser {
    final user = supabase.auth.currentUser;
    print('Current user: ${user?.email ?? 'None'}');
    return user;
  }
} 