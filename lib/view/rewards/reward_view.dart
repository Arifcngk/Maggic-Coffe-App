import 'package:flutter/material.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';

class RewardViewScreen extends StatelessWidget {
  const RewardViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarGlobalWidget(txt: "Reward"),
      body: Center(
        child: Text("Reward"),
      ),
    );
  }
}
