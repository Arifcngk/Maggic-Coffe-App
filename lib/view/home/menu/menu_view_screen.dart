import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuViewScreen extends StatefulWidget {
  const MenuViewScreen({super.key});

  @override
  State<MenuViewScreen> createState() => _MenuViewScreenState();
}

class _MenuViewScreenState extends State<MenuViewScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _tabBar(context),
            _bottomBar(context),
          ],
        ),
      ),
    );
  }

  Positioned _tabBar(BuildContext context) {
    return Positioned.fill(
      top: MediaQuery.of(context).size.height * 0.1,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Color(0xFF324A59),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Select your Coffee",
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFFD8D8D8),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.96,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _coffeeCard(index);
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.coffee_maker_outlined,
                      color: Color(0xFF324A59),
                    ),
                    onPressed: () {
                      // Ana sayfa işlemi
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.card_giftcard_rounded,
                      color: Color(0xFF324A59),
                    ),
                    onPressed: () {
                      // Favorilere ekleme işlemi
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Color(0xFF324A59),
                    ),
                    onPressed: () {
                      // Sepet işlemi
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _coffeeCard(int index) {
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

  Positioned _bottomBar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.02,
      left: 0,
      right: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD8D8D8),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "Alex",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 50, right: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.person_3_outlined,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
