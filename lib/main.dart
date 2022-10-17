import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ownmoneymanagment1/screens/calculationofnetbalence.dart';
import 'package:ownmoneymanagment1/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  //For Firebase Initialization
  //without this error : no firebase app has been created.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(MyApp());

  //new
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //new
  var email = prefs.getString('email');
  //new
  runApp(MaterialApp(
      title: 'Own Money Managment',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: email == null ? LoginScreen() : netBalance()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Own Money Managment',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }
