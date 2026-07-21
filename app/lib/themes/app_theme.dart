import 'package:flutter/material.dart';

/// Saathi Design System — centralised visual tokens.
/// Import this file in any screen to get consistent styling.
class AppTheme {
  AppTheme._(); // prevent instantiation

  // ── PRIMARY (Sky-Blue family, from main.dart gradient) ──
  static const Color primary      = Color(0xFF4DA8DA);
  static const Color primaryLight = Color(0xFF9ED8F6);
  static const Color primaryPale  = Color(0xFFE8F8FC);
  static const Color primaryDark  = Color(0xFF1A6B8A);

  // ── SURFACE ──
  static const Color surface    = Colors.white;
  static const Color surfaceDim = Color(0xFFF5F9FC);
  static const Color background = Color(0xFFF5F9FC);

  // ── SEMANTIC ──
  static const Color accent  = Color(0xFFFFA726);
  static const Color error   = Color(0xFFE53935);
  static const Color success = Color(0xFF66BB6A);

  // ── TEXT ──
  static const Color textPrimary   = Color(0xFF1A2B3C);
  static const Color textSecondary = Color(0xFF6B7D8E);
  static const Color textOnPrimary = Colors.white;

  // ── STANDARD GRADIENT (matches main.dart) ──
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLight, primaryPale, Colors.white],
    stops: [0.0, 0.5, 1.0],
  );

  // ── CORNER RADII ──
  static const double radiusMd     = 8.0;
  static const double radiusLg     = 12.0;
  static const double radiusCard   = 16.0;
  static const double radiusXl     = 20.0;
  static const double radiusButton = 12.0;
  static const double radiusPill   = 40.0;
  static const double radiusInput  = 12.0;

  // ── ELEVATION / SHADOW ──
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  // ── SPACING ──
  static const double spaceXs  = 4.0;
  static const double spaceSm  = 8.0;
  static const double spaceMd  = 12.0;
  static const double spaceLg  = 16.0;
  static const double spaceXl  = 20.0;
  static const double space2xl = 24.0;
  static const double space3xl = 32.0;

  // ── TYPOGRAPHY ──
  static const TextStyle display = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: textPrimary,
  );
  static const TextStyle heading1 = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: textPrimary,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: textPrimary,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: textPrimary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: textPrimary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: textSecondary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: textSecondary,
  );
  static const TextStyle button = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: textOnPrimary,
  );

  // ── APPBAR STYLE ──
  static AppBar standardAppBar(String title, {List<Widget>? actions}) {
    return AppBar(
      title: Text(
        title,
        style: heading2.copyWith(color: primaryDark),
      ),
      backgroundColor: primaryPale,
      elevation: 0,
      foregroundColor: primaryDark,
      actions: actions,
    );
  }

  // ── STANDARD BUTTON STYLE ──
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: textOnPrimary,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusButton),
    ),
    elevation: 0,
    textStyle: button,
  );

  // ── STANDARD INPUT DECORATION ──
  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: bodySmall,
      filled: true,
      fillColor: surfaceDim,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: const BorderSide(color: primaryLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
      ),
    );
  }

  // ── STANDARD CARD DECORATION ──
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radiusCard),
    boxShadow: cardShadow,
  );
}
