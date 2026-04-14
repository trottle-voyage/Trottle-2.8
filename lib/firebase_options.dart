import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web non supporté');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
            'Plateforme non configurée : $defaultTargetPlatform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:            'AIzaSyBol8iySebf9nDahka123A5IWsnynetZDY',
    appId:             '1:721054867211:android:007f7025d97042e8c2cc0e',
    messagingSenderId: '721054867211',
    projectId:         'trottle-2eaf6',
    storageBucket:     'trottle-2eaf6.appspot.com',
  );
}
