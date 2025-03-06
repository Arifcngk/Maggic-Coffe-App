import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonWidget extends StatelessWidget {
  Future<void> Function() onPressed;
   CustomButtonWidget({super.key, required this.onPressed}); 

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: SizedBox(
        width: 355,
        height: 60,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), // Köşe yuvarlaklığı
                color: const Color(0xFF324A59)),
            child: Center(
                child: Text(
              "Next",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
            ))),
      ),
    );
  }
}
