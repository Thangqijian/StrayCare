// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAac1XNjlC2QBgqxrS9bvfE_tVyfx0f43g',
    appId: '1:955859862379:android:15db2c62b564cdaf62822e',
    messagingSenderId: '955859862379',
    projectId: 'pawdar-d6d47',
    storageBucket: 'pawdar-d6d47.firebasestorage.app',
  );
}