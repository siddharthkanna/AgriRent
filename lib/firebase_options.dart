// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrYACMSdNOwk5qiZl0fgG1PiMuj9Z6nyg',
    appId: '1:317799459776:web:b79bf1c18ee1ded52c7625',
    messagingSenderId: '317799459776',
    projectId: 'agrirent-5e481',
    authDomain: 'agrirent-5e481.firebaseapp.com',
    storageBucket: 'agrirent-5e481.appspot.com',
    measurementId: 'G-8CRHYPS3HZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkXNcJtBSYaYMiPc5PeREvxb2cpTlR5Dg',
    appId: '1:317799459776:android:9d90eaebb4a25cf72c7625',
    messagingSenderId: '317799459776',
    projectId: 'agrirent-5e481',
    storageBucket: 'agrirent-5e481.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBraOi6kT-mo4o1fvAAyda1gRGdvd-dhuI',
    appId: '1:317799459776:ios:6335086ab52159752c7625',
    messagingSenderId: '317799459776',
    projectId: 'agrirent-5e481',
    storageBucket: 'agrirent-5e481.appspot.com',
    iosClientId: '317799459776-5hrikcpdhvu0b40karnu3a13cenroukr.apps.googleusercontent.com',
    iosBundleId: 'com.example.agrirent',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBraOi6kT-mo4o1fvAAyda1gRGdvd-dhuI',
    appId: '1:317799459776:ios:c8d329e8698227a72c7625',
    messagingSenderId: '317799459776',
    projectId: 'agrirent-5e481',
    storageBucket: 'agrirent-5e481.appspot.com',
    iosClientId: '317799459776-5q5p9ii9em96o595beqgmb69pdn52pb5.apps.googleusercontent.com',
    iosBundleId: 'com.example.agrirent.RunnerTests',
  );
}
