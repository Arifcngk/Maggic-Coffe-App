import 'package:flutter/material.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';

class MyOrderView extends StatelessWidget {
  const MyOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarGlobalWidget(txt: "My Order"),
      body: Center(
        child: Text("My Order"),
      ),
    );
  }
}
