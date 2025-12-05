import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Ethiopian-inspired color palette
  static const Color ethiopianGreen = Color(0xFF009639);
  static const Color ethiopianYellow = Color(0xFFFEDB00);
  static const Color ethiopianRed = Color(0xFFDA121A);
  static const Color deepBlue = Color(0xFF1A237E);
  static const Color skyBlue = Color(0xFF0288D1);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ethiopianGreen,
        brightness: Brightness.light,
        primary: ethiopianGreen,
        secondary: ethiopianYellow,
        tertiary: deepBlue,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      // cardTheme: const CardTheme(
      //   elevation: 4,
      //   margin: EdgeInsets.zero,
      // ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ethiopianGreen,
        brightness: Brightness.dark,
        primary: ethiopianGreen,
        secondary: ethiopianYellow,
        tertiary: skyBlue,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      // cardTheme: const CardTheme(
      //   elevation: 4,
      //   margin: EdgeInsets.zero,
      // ),
    );
  }
  
  // Custom gradients
  static const LinearGradient ethiopianGradient = LinearGradient(
    colors: [ethiopianGreen, ethiopianYellow, ethiopianRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient skyGradient = LinearGradient(
    colors: [deepBlue, skyBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
