import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        primary: Colors.black,
        surface: Colors.white,
        secondary: Colors.white),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        overlayColor: WidgetStatePropertyAll(Colors.black.withOpacity(0.2))),
    useMaterial3: true,
  );

  static const TextStyle boldText = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle greyText = TextStyle(color: Colors.grey);
}
