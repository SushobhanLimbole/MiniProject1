import 'package:flutter/material.dart';
import 'package:venue_vista/Pages/SignInPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:venue_vista/Components/constants.dart';
import 'package:venue_vista/firebase_options.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  //await dotenv.load(fileName: 'assets/.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: SignInPage(),
    );
  }
}
