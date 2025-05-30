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
    apiKey: 'AIzaSyAUrtxauSrwxCTvhPHzHXnTwruF1QaFy_Q',
    appId: '1:340639656374:web:18f1310a9ec448c14ef917',
    messagingSenderId: '340639656374',
    projectId: 'gig-finder-812b9',
    authDomain: 'gig-finder-812b9.firebaseapp.com',
    storageBucket: 'gig-finder-812b9.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATZqu0JTQ7gND7jvvm-nzKH-w1EqIRsgY',
    appId: '1:340639656374:android:0c75781db62ed2114ef917',
    messagingSenderId: '340639656374',
    projectId: 'gig-finder-812b9',
    storageBucket: 'gig-finder-812b9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdnSZn4grmQyqQAvCTDo0En4G_b_lDz6s',
    appId: '1:340639656374:ios:2059e643a282a8f44ef917',
    messagingSenderId: '340639656374',
    projectId: 'gig-finder-812b9',
    storageBucket: 'gig-finder-812b9.firebasestorage.app',
    iosBundleId: 'com.example.gigFinder',
  );
}
