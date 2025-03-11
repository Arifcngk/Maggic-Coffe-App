import 'package:flutter/material.dart';
import 'package:maggic_coffe/view/home/menu/widgets/coffe_list_widget.dart';
import 'package:maggic_coffe/view/home/menu/widgets/welcome_user_bar_widget.dart';

class MenuViewScreen extends StatefulWidget {
  const MenuViewScreen({super.key});

  @override
  State<MenuViewScreen> createState() => _MenuViewScreenState();
}

class _MenuViewScreenState extends State<MenuViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
          const  CoffeeListWidget(),
            WelcomeUserBarWidget(context: context),
          ],
        ),
      ),
    );
  }
}
