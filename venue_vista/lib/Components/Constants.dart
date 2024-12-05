import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color.fromRGBO(243, 193, 202, 1);
const secondaryColor = Color.fromRGBO(80, 37, 112, 1);

AppBarTheme customAppBarTheme = AppBarTheme(
  backgroundColor: primaryColor,
  iconTheme: const IconThemeData(color: secondaryColor),
  titleTextStyle: GoogleFonts.poppins(
    color: secondaryColor,
    fontSize: 20.0,
  ),
);

ThemeData themeData = ThemeData(
  appBarTheme: customAppBarTheme,
  iconTheme: const IconThemeData(color: secondaryColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(secondaryColor),
      backgroundColor: WidgetStateProperty.all(primaryColor),
      textStyle: WidgetStateProperty.all(
        GoogleFonts.notoSans(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: secondaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: secondaryColor, width: 2.0),
    ),
    labelStyle: GoogleFonts.poppins(color: secondaryColor),
    hintStyle: GoogleFonts.poppins(color: secondaryColor),
    prefixIconColor: secondaryColor
  ),
);
