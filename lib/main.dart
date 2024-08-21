import 'package:admin_panel/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'Utils/Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await initializeFirebase();
  await Server.initialize();
  print(Server.url);
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCpYmV6_eWAXawJRm18rIm8FOueASjB1_k",
        authDomain: "duckindia-a177a.firebaseapp.com",
        projectId: "duckindia-a177a",
        storageBucket: "duckindia-a177a.appspot.com",
        messagingSenderId: "914969931032",
        appId: "1:914969931032:web:203e369f4949bdc909c26d",
        measurementId: "G-5H76LYJ3JV"),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WELCOME',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => const MyHomePage(),
      },
    );
  }
}
