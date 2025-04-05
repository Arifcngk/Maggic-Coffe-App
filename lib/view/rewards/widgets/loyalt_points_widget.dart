import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class loyaltyPointsWidget extends StatelessWidget {
  const loyaltyPointsWidget({
    super.key,
    required this.coffeeActive,
    required this.coffeeMax,
    required this.coffeeImages,
  });

  final int coffeeActive;
  final int coffeeMax;
  final List<Widget> coffeeImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Card(
        color: const Color(0xFF324A59),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Loyalty Points",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Text(
                    "$coffeeActive/$coffeeMax",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: coffeeImages, // Resimlerin listesi burada
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
