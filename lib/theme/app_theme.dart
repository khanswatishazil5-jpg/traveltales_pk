import 'package:flutter/material.dart';

/// Central design tokens for Travel Tales.
/// Palette: warm sand paper + ink navy + sunset coral + deep teal + postmark gold.
class AppColors {
  static const paper = Color(0xFFEFE3C8);
  static const card = Color(0xFFFBF6E9);
  static const ink = Color(0xFF1F2A44);
  static const charcoal = Color(0xFF2B2620);
  static const coral = Color(0xFFFF6B4A);
  static const teal = Color(0xFF0F5257);
  static const gold = Color(0xFFC89B3C);
  static const line = Color(0x241F2A44); // ink at ~14% opacity
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.paper,
      primaryColor: AppColors.ink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.ink,
        secondary: AppColors.coral,
        surface: AppColors.card,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.coral, width: 2),
        ),
      ),
      useMaterial3: true,
    );
  }
}
