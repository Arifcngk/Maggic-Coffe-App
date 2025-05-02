import 'package:flutter/material.dart';
import 'package:maggic_coffe/view/home/menu/menu_view_screen.dart';
import 'package:maggic_coffe/view/home/order/my_order_view.dart';
import 'package:maggic_coffe/view/home/reward/loyalty_screen.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    MenuViewScreen(),
    LoyaltyScreen(),
    MyOrderView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pages[_selectedIndex] is MenuViewScreen
          ? const Color(0xFF324A59)
          : Colors.white,
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF356697).withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            enableFeedback: false,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Image(
                      image: const AssetImage(
                        'assets/icon/home.png',
                      ),
                      width: 21,
                      height: 21,
                      color: _selectedIndex == 0
                          ? const Color(0xFF324A59)
                          : const Color(0xFFD8D8D8),
                    ),
                  ],
                ),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Image(
                      image: const AssetImage(
                        'assets/icon/gift.png',
                      ),
                      width: 21,
                      height: 21,
                      color: _selectedIndex == 1
                          ? const Color(0xFF324A59)
                          : const Color(0xFFD8D8D8),
                    ),
                  ],
                ),
                label: 'Gift',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Image(
                      image: const AssetImage(
                        'assets/icon/order.png',
                      ),
                      width: 21,
                      height: 21,
                      color: _selectedIndex == 2
                          ? const Color(0xFF324A59)
                          : const Color(0xFFD8D8D8),
                    ),
                  ],
                ),
                label: "My Order",
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
