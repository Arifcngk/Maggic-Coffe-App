import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/coffe_lover_card_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_button_widget.dart';

import 'package:maggic_coffe/view/home/order_options/widgets/custom_text_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/image_product_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/onsite_takeaway_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/product_volume_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/ristretto_widget.dart';

class OrderOptionsViewScreen extends StatefulWidget {
  const OrderOptionsViewScreen({super.key});

  @override
  State<OrderOptionsViewScreen> createState() => _OrderOptionsViewScreenState();
}

class _OrderOptionsViewScreenState extends State<OrderOptionsViewScreen> {
  int count = 1; // Sayı başlangıç değeri

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    if (count > 1) {
      setState(() {
        count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarGlobalWidget(txt: "Order"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            const ImageWidget(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  _productQuantity(),
                  _divider(),
                  const ProductRistrettoWidget(),
                  _divider(),
                  const ProductVolumeWidget(),
                  _divider(),
                  const OnsiteTakeawayWidget(),
                  _divider(),
                  const CoffeLoverCardWidget(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  _totalBuy(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  const CustomButtonWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _totalBuy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Total Amount", fontSize: 20),
        Text(
          "BYN 3.00",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        )
      ],
    );
  }

  Row _productQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Latte", fontSize: 18),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            width: 110,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD8D8D8), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Eksiltme Butonu
                IconButton(
                  onPressed: decrement,
                  icon: const Icon(Icons.remove, size: 15),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                // Sayı
                Text(
                  "$count",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Artırma Butonu
                IconButton(
                  onPressed: increment,
                  icon: const Icon(Icons.add, size: 15),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(
        thickness: 2,
        color: Color(0xFFF4F5F7),
      ),
    );
  }
}
