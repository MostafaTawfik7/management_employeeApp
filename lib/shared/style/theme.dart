import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 8,
      ),
      fillColor: Colors.grey.shade50,
      filled: true,
      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.2),
          borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.2),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 1.2),
          borderRadius: BorderRadius.circular(10)),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
          borderRadius: BorderRadius.circular(10)),
    ),
  );
}
