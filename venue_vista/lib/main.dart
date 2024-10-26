import 'package:flutter/material.dart';
import 'package:venue_vista/Pages/HomePage.dart';
import 'package:venue_vista/Pages/SignUpPage.dart';
import 'package:venue_vista/Pages/Test.dart';
import 'package:venue_vista/Pages/TimePicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
  }
}
