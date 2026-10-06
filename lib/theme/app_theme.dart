import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (Sama persis dengan EWS-WEB index.css)
  static const Color brandGreen = Color(0xFF138568);
  static const Color brandGreenDark = Color(0xFF0E634D);
  static const Color brandGreenLight = Color(0xFFEAF5EE);

  // Background & Surfaces
  static const Color bgLight = Color(0xFFF7F9F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5EBE7);
  static const Color borderSubtle = Color(0xFFEDF1EE);

  // Typography Colors
  static const Color textPrimary = Color(0xFF263B35);
  static const Color textMuted = Color(0xFF74827C);
  static const Color textSubtle = Color(0xFF93A097);

  // Status: Danger / Bahaya
  static const Color danger = Color(0xFFB52D35);
  static const Color dangerBg = Color(0xFFFFF0EF);
  static const Color dangerBorder = Color(0xFFEDC9CC);
  static const Color dangerSymbol = Color(0xFFF9D7D9);

  // Status: Warning / Mendekati Batas (Amber)
  static const Color warning = Color(0xFFAE781A);
  static const Color warningBg = Color(0xFFFFFBEF);
  static const Color warningBorder = Color(0xFFEEE3C6);
  static const Color warningSymbol = Color(0xFFF6E8BE);

  // Status: Safe / Aman
  static const Color safe = Color(0xFF1A8664);
  static const Color safeBg = Color(0xFFEDF7F0);
  static const Color safeBorder = Color(0xFFC8E6D9);

  // Status: Offline / Data Terputus
  static const Color offline = Color(0xFF758078);
  static const Color offlineBg = Color(0xFFF1F3F2);
  static const Color offlineBorder = Color(0xFFE0E5E2);

  // River water accents
  static const Color riverWater = Color(0xFFE6F3F2);
  static const Color riverBorder = Color(0xFF71B6AA);
  static const Color riverText = Color(0xFF438B7D);

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.dmSansTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: brandGreen,
      colorScheme: const ColorScheme.light(
        primary: brandGreen,
        secondary: brandGreenDark,
        surface: surface,
        error: danger,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: brandGreen,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
