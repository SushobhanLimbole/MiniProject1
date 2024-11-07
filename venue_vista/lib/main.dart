import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:venue_vista/Pages/HomePage.dart';
import 'package:venue_vista/Pages/SignInPage.dart';
// import 'package:venue_vista/Pages/SignUpPage.dart';
// import 'package:venue_vista/Pages/Test.dart';
// import 'package:venue_vista/Pages/TimePicker.dart';
import 'package:venue_vista/constants.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
