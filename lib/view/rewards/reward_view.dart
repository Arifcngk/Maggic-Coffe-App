import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardViewScreen extends StatelessWidget {
  const RewardViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek veri
    int coffeeActive = 2; // "Aktif" olan kahve sayısı
    int coffeeMax = 8; // Maksimum resim sayısı
    int coffeeNotActive =
        coffeeMax - coffeeActive; // "Aktif olmayan" kahve sayısı

    // "coffe_cupe.png" ve "coffe_cupe_1.png" resimlerinin listelerini oluştur
    List<Widget> coffeeImages = List.generate(
      coffeeActive,
      (index) => Image.asset(
        "assets/img/coffe_cupe.png",
        width: 30,
        height: 30,
      ),
    )..addAll(
        List.generate(
          coffeeNotActive,
          (index) => Image.asset(
            "assets/img/coffe_cupe_1.png",
            width: 30,
            height: 30,
          ),
        ),
      );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Reward",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            _loyaltyPoints(coffeeActive, coffeeMax, coffeeImages),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            _myPoints()
          ],
        ),
      ),
    );
  }

  SizedBox _myPoints() {
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

  SizedBox _loyaltyPoints(
      int coffeeActive, int coffeeMax, List<Widget> coffeeImages) {
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
