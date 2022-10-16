import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ownmoneymanagment1/screens/login.dart';

Future<void> main() async {
  //For Firebase Initialization
  //without this error : no firebase app has been created.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Own Money Managment',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const LoginScreen(),
    );
  }
}

