import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maggic_coffe/view/auth/signin_view_screen.dart';

class StartupViewScreen extends StatefulWidget {
  const StartupViewScreen({super.key});

  @override
  State<StartupViewScreen> createState() => _StartupViewScreenState();
}

class _StartupViewScreenState extends State<StartupViewScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SigninViewScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arka Plan Resmimizi Ekleyelim
          Image.asset(
            "assets/img/bg.jpg",
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Image.asset(
                  "assets/logo/logo.png",
                  width: 500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
