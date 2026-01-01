import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class DefaultFirebaseOptions {
  static const String projectId = 'holymessages-a240d';
  static const String storageBucket = 'holymessages-a240d.firebasestorage.app';
  static const String messagingSenderId = '475899270664';
  // webClientId obtido do GoogleService-Info.plist (CLIENT_ID)
  static const String webClientId = '475899270664-d9mllk42r68td8djes4ub5n39uk3fn92.apps.googleusercontent.com';
  
  static FirebaseOptions get currentPlatform {
    if (Platform.isIOS) {
      return ios;
    } else if (Platform.isAndroid) {
      return android;
    }
    throw UnsupportedError('Plataforma não suportada');
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwu-HjPLIomBgzBt9OnSlgeFLEOwBuCWQ',
    appId: '1:475899270664:ios:6cfc059975d90515ac63bd',
    messagingSenderId: '475899270664',
    projectId: 'holymessages-a240d',
    storageBucket: 'holymessages-a240d.firebasestorage.app',
    iosBundleId: 'com.holyapp.messages',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVDQ6tfiJ0fRp9kuXryv7JDwJN2p_dNJ8',
    appId: '1:475899270664:android:1142c2fe3cff51c7ac63bd',
    messagingSenderId: '475899270664',
    projectId: 'holymessages-a240d',
    storageBucket: 'holymessages-a240d.firebasestorage.app',
  );
}

