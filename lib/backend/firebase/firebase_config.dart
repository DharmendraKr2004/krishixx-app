import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDl82ti3NI7iYRBIs1UqZiKfhYUhb2ZBjc",
        authDomain: "krishix-dharm.firebaseapp.com",
        projectId: "krishix-dharm",
        storageBucket: "krishix-dharm.firebasestorage.app",
        messagingSenderId: "1029979969082",
        appId: "1:1029979969082:web:845044cec2b107cc6a8703",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}
