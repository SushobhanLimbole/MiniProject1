// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAdHQabOLvOO_fvd7_IZr-voUTDeH3Yjl0',
    appId: '1:904758558916:web:b0602f21f861de38034991',
    messagingSenderId: '904758558916',
    projectId: 'venue-vista-c9339',
    authDomain: 'venue-vista-c9339.firebaseapp.com',
    databaseURL: 'https://venue-vista-c9339-default-rtdb.firebaseio.com',
    storageBucket: 'venue-vista-c9339.firebasestorage.app',
    measurementId: 'G-R26Z7H9W9L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHJwQurgef7TTUwudiFhIF3Q95RpZhev0',
    appId: '1:904758558916:android:b770bcef031eec65034991',
    messagingSenderId: '904758558916',
    projectId: 'venue-vista-c9339',
    databaseURL: 'https://venue-vista-c9339-default-rtdb.firebaseio.com',
    storageBucket: 'venue-vista-c9339.firebasestorage.app',
  );
}