import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class myPointsWidget extends StatelessWidget {
  const myPointsWidget({
    super.key,
  });

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
        child: Stack(
          children: [
            // Sol alt köşeye yerleştirilecek resim
            Positioned(
              right: -15,
              bottom: -20,
              child: Image.asset(
                "assets/img/coffe_core.png", // Görselin yolunu buraya yazın
                width: 66,
                height: 66,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Points",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    Text(
                      "1232",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B7383),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      side: const BorderSide(
                          color: Colors.transparent, width: 1)),
                  child: Text(
                    "Redeem Drinks",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}