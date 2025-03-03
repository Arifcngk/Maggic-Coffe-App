import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseTextWidget extends StatelessWidget {
  String txt1;
  String txt2;
  BaseTextWidget({super.key, required this.txt1, required this.txt2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txt1,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              color: const Color(0xFF181D2D)),
        ),
        const SizedBox(height: 24),
        Text(
          txt2,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: const Color(0xFFAAAAAA)),
        ),
      ],
    );
  }
}
