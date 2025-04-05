import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    // Genel renk şeması
    primaryColor: const Color(0xFF324A59),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFF7F8FB),
      secondary: Color(0xFF324A59),
      surface: Colors.white, // Yüzey rengi
      onPrimary: Colors.white, // Primary renk üzerindeki metin rengi
      onSecondary: Colors.white,
      onSurface: Color(0xFF8592A6),
    ),

    // appbar theme property
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: const Color(0xFF001833),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
