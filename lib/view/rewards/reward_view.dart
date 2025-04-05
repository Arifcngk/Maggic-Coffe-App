import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/view/rewards/widgets/loyalt_points_widget.dart';
import 'package:maggic_coffe/view/rewards/widgets/my_points_widget.dart';

class RewardViewScreen extends StatelessWidget {
  const RewardViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int coffeeActive = 2;
    int coffeeMax = 8;
    int coffeeNotActive = coffeeMax - coffeeActive;

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

    // Örnek reward verileri
    final List<Map<String, String>> rewardHistory = [
      {"title": "Latte", "date": "24 June | 12.30", "points": "+12 Pts"},
      {"title": "Espresso", "date": "23 June | 09.15", "points": "+10 Pts"},
      {"title": "Cappuccino", "date": "22 June | 14.20", "points": "+15 Pts"},
      {"title": "Americano", "date": "21 June | 17.45", "points": "+8 Pts"},
      {"title": "Mocha", "date": "20 June | 11.00", "points": "+13 Pts"},
      {"title": "Macchiato", "date": "19 June | 08.40", "points": "+9 Pts"},
      {"title": "Flat White", "date": "18 June | 10.30", "points": "+11 Pts"},
    ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loyaltyPointsWidget(
              coffeeActive: coffeeActive,
              coffeeMax: coffeeMax,
              coffeeImages: coffeeImages,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const myPointsWidget(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "History Rewards",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF324A59),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: rewardHistory.length,
                itemBuilder: (context, index) {
                  final reward = rewardHistory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward["title"]!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF324A59),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.004),
                            Text(
                              reward["date"]!,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: const Color(0xFFD8D8D8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          reward["points"]!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF324A59),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
