import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class textWidget extends StatelessWidget {
  const textWidget({
    super.key,
    required this.txt,
    required this.fontSize,
  });

  final String txt;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: GoogleFonts.dmSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF001833)),
    );
  }
}
