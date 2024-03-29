// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
    // case TargetPlatform.iOS:
    //   return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD30xzdyD9yI5YHZrHFyG8ff_N1TbQYH04',
    appId: '1:741937452708:android:e1584bfe5307f6eda3b831',
    messagingSenderId: '741937452708',
    projectId: 'pinterestmobile-2fa98',
    storageBucket: 'pinterestmobile-2fa98.appspot.com',
  );

// static const FirebaseOptions ios = FirebaseOptions(
//   apiKey: 'AIzaSyD0pDRoqJdNJMWXavFqNm1j6oUrzOLCt-4',
//   appId: '1:633054477323:ios:802a221fdcbde1886a5b0e',
//   messagingSenderId: '633054477323',
//   projectId: 'b17-insta-clone',
//   storageBucket: 'b17-insta-clone.appspot.com',
//   iosClientId: '633054477323-pspjjla4bi50hldarpt5ms3ervpg5hne.apps.googleusercontent.com',
//   iosBundleId: 'com.example.instagramClone',
// );
}