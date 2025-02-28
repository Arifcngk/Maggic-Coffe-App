import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CaffeMapView extends StatefulWidget {
  const CaffeMapView({super.key});

  @override
  State<CaffeMapView> createState() => _CaffeMapViewState();
}

class _CaffeMapViewState extends State<CaffeMapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324A59),
      body: Stack(
        children: [
          // Üstteki Harita Bölgesi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7, // %40 Yükseklik
              child: Image.asset(
                "assets/img/maps.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Alt Bölüm (Başlık ve Liste)
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fazladan boşluk bırakmaz
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Metni sola hizalar
              children: [
                // Alan-1 (Başlık)
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF324A59),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  width: double.infinity,
                  child: Text(
                    "Select Magic Coffe store",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                // Alan-2 (Liste)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height *
                      0.27, // %25 Yükseklik
                  child: _coffeStores(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _coffeStores() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 14, right: 20, left: 20),
      itemCount: 5, // Örnek olarak 5 öğe koydum
      itemBuilder: (context, index) {
        return Container(
          height: 60, // Konteyner yüksekliği
          margin: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // Köşe yuvarlaklığı
            gradient: const LinearGradient(
              colors: [
                Color(0xFFEEA4CE),
                Color(0xFFC58BF2)
              ], // Gradient renkler
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                offset: Offset(2, 4), // Gölge efekti
              ),
            ],
          ),
          child: Center(
            child: ListTile(
              leading: const Icon(
                Icons.storefront,
                color: Colors.white,
                size: 30,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Kahve Dünyası Gebze ",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
