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
    apiKey: 'AIzaSyARSvGk-cEqRutJoiBe49QaKCkU-bF-oMU',
    appId: '1:760393724374:web:1dab20207745a4a93ef477',
    messagingSenderId: '760393724374',
    projectId: 'loreto-847ab',
    authDomain: 'loreto-847ab.firebaseapp.com',
    storageBucket: 'loreto-847ab.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsPXUJdHFphlERPPhxACfhZNarnbWcrJs',
    appId: '1:760393724374:android:71e68564edf884b43ef477',
    messagingSenderId: '760393724374',
    projectId: 'loreto-847ab',
    storageBucket: 'loreto-847ab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvrrPEF0ty_4s0ne0_Egk70gfhELc91Ow',
    appId: '1:760393724374:ios:2c90ed0a24de5b5d3ef477',
    messagingSenderId: '760393724374',
    projectId: 'loreto-847ab',
    storageBucket: 'loreto-847ab.appspot.com',
    iosBundleId: 'com.example.smartclassmate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBvrrPEF0ty_4s0ne0_Egk70gfhELc91Ow',
    appId: '1:760393724374:ios:2c90ed0a24de5b5d3ef477',
    messagingSenderId: '760393724374',
    projectId: 'loreto-847ab',
    storageBucket: 'loreto-847ab.appspot.com',
    iosBundleId: 'com.example.smartclassmate',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARSvGk-cEqRutJoiBe49QaKCkU-bF-oMU',
    appId: '1:760393724374:web:39ff2d66b8fd5b2e3ef477',
    messagingSenderId: '760393724374',
    projectId: 'loreto-847ab',
    authDomain: 'loreto-847ab.firebaseapp.com',
    storageBucket: 'loreto-847ab.appspot.com',
  );
}
