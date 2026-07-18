import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design tokens for Travel Tales.
///
/// Palette: a "northern Pakistan trail" feel — deep forest ink, warm sand
/// paper, terracotta for calls to action, muted pine for secondary accents,
/// and a soft sun-gold for borders/highlights. Field names are kept the
/// same as the original postcard theme (paper/card/ink/coral/teal/gold/line)
/// so every screen and widget that already references AppColors.* just
/// picks up the new look automatically — no per-file rewiring needed.
class AppColors {
  static const paper = Color(0xFFF3EFDF); // warm sand background
  static const card = Color(0xFFFFFDF6); // soft cream card surface
  static const ink = Color(0xFF1E3A2F); // deep forest — headers & primary text
  static const charcoal = Color(0xFF2E2B22); // body text
  static const coral = Color(0xFFDD7A3A); // terracotta — CTAs, likes, accents
  static const teal = Color(0xFF2E7D6B); // muted pine — secondary accent
  static const gold = Color(0xFFC9A227); // sun gold — borders, highlights
  static const line = Color(0x241E3A2F); // ink at ~14% opacity
}

/// Font helpers so every screen references one place instead of a raw
/// string. Uses Google Fonts (fetched at runtime), which is what actually
/// makes these appear correctly — no .ttf files need to be bundled.
class AppFonts {
  static String get display => GoogleFonts.fraunces().fontFamily!;
  static String get mono => GoogleFonts.spaceMono().fontFamily!;
}

/// Simple responsive helper: keeps content comfortably readable on tablet/
/// web/desktop widths while staying completely untouched on phones (the
/// primary target), where the constraint never actually kicks in.
class AppLayout {
  static const double maxContentWidth = 560;
}

class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  const ResponsiveCenter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: child,
      ),
    );
  }
}

class AppTheme {
  static ThemeData light() {
    final baseTextTheme = GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      scaffoldBackgroundColor: AppColors.paper,
      primaryColor: AppColors.ink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.ink,
        secondary: AppColors.coral,
        surface: AppColors.card,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: AppColors.charcoal,
        displayColor: AppColors.ink,
      ),
      fontFamily: GoogleFonts.nunito().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.display,
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.coral, width: 2),
        ),
      ),
      useMaterial3: true,
    );
  }
}
