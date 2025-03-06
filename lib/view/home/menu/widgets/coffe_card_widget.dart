import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeCardWidget extends StatelessWidget {
  const CoffeCardWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/latte.png",
              width: 120,
              height: 90,
            ),
            const SizedBox(height: 10),
            Text(
              "Coffee ${index + 1}",
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
