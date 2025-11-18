import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTq7kzKYS8DySbwM8JfzdZocs2aRFUQwY',
    appId: '1:284994311059:android:12c07c25af499893524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    databaseURL:
        'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOry_QqrymqkX9K_YOEoAJ_DF-lxl5LPk',
    appId: '1:284994311059:ios:92da814a6c8b027f524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    databaseURL:
        'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
    iosClientId:
        '284994311059-he7bdqs24rjqp30jj6pe28qvgf35sn4m.apps.googleusercontent.com',
    iosBundleId: 'com.example.vitaro',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBCCSSYoh53jADaBdaG1j8-QaiGSRxJFRg',
    appId: '1:284994311059:web:810c77d12b1fe6eb524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    authDomain: 'vitaro-4d136.firebaseapp.com',
    databaseURL:
        'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
    measurementId: 'G-CSVV8PTC9D',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOry_QqrymqkX9K_YOEoAJ_DF-lxl5LPk',
    appId: '1:284994311059:ios:92da814a6c8b027f524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    databaseURL:
        'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
    iosClientId:
        '284994311059-he7bdqs24rjqp30jj6pe28qvgf35sn4m.apps.googleusercontent.com',
    iosBundleId: 'com.example.vitaro',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBCCSSYoh53jADaBdaG1j8-QaiGSRxJFRg',
    appId: '1:284994311059:web:810c77d12b1fe6eb524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    authDomain: 'vitaro-4d136.firebaseapp.com',
    databaseURL: 'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
    measurementId: 'G-CSVV8PTC9D',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOry_QqrymqkX9K_YOEoAJ_DF-lxl5LPk',
    appId: '1:284994311059:ios:92da814a6c8b027f524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    databaseURL: 'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
    iosClientId: '284994311059-he7bdqs24rjqp30jj6pe28qvgf35sn4m.apps.googleusercontent.com',
    iosBundleId: 'com.example.vitaro',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCCSSYoh53jADaBdaG1j8-QaiGSRxJFRg',
    appId: '1:284994311059:web:c10ad3683a433039524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    authDomain: 'vitaro-4d136.firebaseapp.com',
    databaseURL: 'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
    measurementId: 'G-0TN4E88BL8',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCCSSYoh53jADaBdaG1j8-QaiGSRxJFRg',
    appId: '1:284994311059:web:c10ad3683a433039524e66',
    messagingSenderId: '284994311059',
    projectId: 'vitaro-4d136',
    authDomain: 'vitaro-4d136.firebaseapp.com',
    databaseURL:
        'https://vitaro-4d136-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'vitaro-4d136.firebasestorage.app',
    measurementId: 'G-0TN4E88BL8',
  );
}
