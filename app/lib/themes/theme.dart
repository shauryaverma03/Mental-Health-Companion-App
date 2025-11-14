import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Mint),
  // Set scaffoldBackgroundColor to a subtle sky tint (for solid-color backgrounds).
  // If you want an actual gradient everywhere, see notes below.
  scaffoldBackgroundColor: const Color(0xFFE8F8FC), // light sky tint
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  // Optional: default elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Mint,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  // Add other theme settings (textTheme, cardTheme, etc.) as needed.
);