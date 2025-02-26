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
    apiKey: 'AIzaSyCWMQH-8-M_Gc4FoJ-Mq3QrrRaWl7HrLhI',
    appId: '1:526368163219:web:b51651560f48be0e831466',
    messagingSenderId: '526368163219',
    projectId: 'ihelpcrm',
    authDomain: 'ihelpcrm.firebaseapp.com',
    storageBucket: 'ihelpcrm.firebasestorage.app',
    measurementId: 'G-W6J02N8BF7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPJjvhPHFdnVgdAWRDNEGw8Y9eIgyTjWE',
    appId: '1:526368163219:android:6be3ffd861d9ad46831466',
    messagingSenderId: '526368163219',
    projectId: 'ihelpcrm',
    storageBucket: 'ihelpcrm.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAl0P_bGFRyZ4Ptd4qhTkmED3rvxpLxkpM',
    appId: '1:526368163219:ios:a9a801bbed056b35831466',
    messagingSenderId: '526368163219',
    projectId: 'ihelpcrm',
    storageBucket: 'ihelpcrm.firebasestorage.app',
    iosBundleId: 'com.example.untitled1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAl0P_bGFRyZ4Ptd4qhTkmED3rvxpLxkpM',
    appId: '1:526368163219:ios:a9a801bbed056b35831466',
    messagingSenderId: '526368163219',
    projectId: 'ihelpcrm',
    storageBucket: 'ihelpcrm.firebasestorage.app',
    iosBundleId: 'com.example.untitled1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCWMQH-8-M_Gc4FoJ-Mq3QrrRaWl7HrLhI',
    appId: '1:526368163219:web:6b20efd29071e102831466',
    messagingSenderId: '526368163219',
    projectId: 'ihelpcrm',
    authDomain: 'ihelpcrm.firebaseapp.com',
    storageBucket: 'ihelpcrm.firebasestorage.app',
    measurementId: 'G-55QSL22Y81',
  );

}