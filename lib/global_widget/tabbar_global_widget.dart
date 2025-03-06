import 'package:flutter/material.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/view/home/menu/menu_view_screen.dart';
import 'package:maggic_coffe/view/home/order/my_order_view.dart';
import 'package:maggic_coffe/view/rewards/reward_view.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    MenuViewScreen(),
    RewardViewScreen(),
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

      body: _pages[_selectedIndex], // Seçilen sayfayı göster
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Color(0xFFF4F5F7),
              selectedItemColor: const Color(0xFF324A59), // Seçili ikon rengi
              unselectedItemColor:
                  const Color(0xFFD8D8D8), // Seçili olmayan ikon rengi
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.coffee_maker_outlined),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard_rounded),
                  label: 'Reward',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'My Order',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
