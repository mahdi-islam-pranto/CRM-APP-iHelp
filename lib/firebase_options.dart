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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCHJvGVDMGOffVIntlj2Do5Z9b-puECIZI',
    appId: '1:597249513001:web:58fac386552e8aebe52e38',
    messagingSenderId: '597249513001',
    projectId: 'icrm-app',
    authDomain: 'icrm-app.firebaseapp.com',
    storageBucket: 'icrm-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmIsK0G9mtJgS50dtsWD2ZkDpd0z_zp1E',
    appId: '1:597249513001:android:f588c0b2510570ffe52e38',
    messagingSenderId: '597249513001',
    projectId: 'icrm-app',
    storageBucket: 'icrm-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_AvZ5e2ZcXhrDn-ear1GhGi1Wx7DSBkI',
    appId: '1:597249513001:ios:50f58da13fa5a9abe52e38',
    messagingSenderId: '597249513001',
    projectId: 'icrm-app',
    storageBucket: 'icrm-app.appspot.com',
    iosBundleId: 'com.example.untitled1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_AvZ5e2ZcXhrDn-ear1GhGi1Wx7DSBkI',
    appId: '1:597249513001:ios:50f58da13fa5a9abe52e38',
    messagingSenderId: '597249513001',
    projectId: 'icrm-app',
    storageBucket: 'icrm-app.appspot.com',
    iosBundleId: 'com.example.untitled1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCHJvGVDMGOffVIntlj2Do5Z9b-puECIZI',
    appId: '1:597249513001:web:ca357703355f94e3e52e38',
    messagingSenderId: '597249513001',
    projectId: 'icrm-app',
    authDomain: 'icrm-app.firebaseapp.com',
    storageBucket: 'icrm-app.appspot.com',
  );
}