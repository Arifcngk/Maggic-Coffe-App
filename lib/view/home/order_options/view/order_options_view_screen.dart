import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/models/coffee.dart';
import 'package:maggic_coffe/view/home/order_options/view/cart_item_view_screen.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/coffe_lover_card_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_button_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_text_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/image_product_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/onsite_takeaway_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/product_volume_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/ristretto_widget.dart';
import 'package:maggic_coffe/services/cart_service.dart';
import 'package:maggic_coffe/models/cart_item.dart';

class OrderOptionsViewScreen extends StatefulWidget {
  final Coffee coffee;

  const OrderOptionsViewScreen({super.key, required this.coffee});

  @override
  State<OrderOptionsViewScreen> createState() => _OrderOptionsViewScreenState();
}

class _OrderOptionsViewScreenState extends State<OrderOptionsViewScreen> {
  int count = 1;
  int selectedVolumeMl = 250;
  bool isTakeaway = false;
  final CartService _cartService = CartService();

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

  Future<void> addToCart() async {
    final cartItem = CartItem(
      coffee: widget.coffee,
      quantity: count,
      volumeMl: selectedVolumeMl,
      isTakeaway: isTakeaway,
      intensity: 'light', // Varsayılan değer
    );

    _cartService.addItem(cartItem);
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartItemViewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double basePrice = widget.coffee.price;
    double volumePrice = 0;

    // Add price differences based on volume
    if (selectedVolumeMl == 350) {
      volumePrice = 10; // 10 TL extra for 350ml
    } else if (selectedVolumeMl == 450) {
      volumePrice = 20; // 20 TL extra for 450ml
    }

    final totalPrice = (basePrice + volumePrice) * count;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarGlobalWidget(txt: widget.coffee.coffeeName),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            ImageWidget(imageUrl: widget.coffee.imageUrl),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  _productQuantity(),
                  _divider(),
                  ProductRistrettoWidget(coffee: widget.coffee),
                  _divider(),
                  ProductVolumeWidget(
                    coffee: widget.coffee,
                    onVolumeSelected: (volume) {
                      setState(() {
                        selectedVolumeMl = volume;
                      });
                    },
                  ),
                  _divider(),
                  OnsiteTakeawayWidget(
                    onSelectionChanged: (value) {
                      setState(() {
                        isTakeaway = value;
                      });
                    },
                  ),
                  _divider(),
                  const CoffeLoverCardWidget(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  _totalBuy(totalPrice),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  CustomButtonWidget(
                    onPressed: addToCart,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _totalBuy(double totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Total Amount", fontSize: 20),
        Text(
          "BYN ${totalPrice.toStringAsFixed(2)}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Row _productQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWidget(txt: widget.coffee.coffeeName, fontSize: 18),
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
                IconButton(
                  onPressed: decrement,
                  icon: const Icon(Icons.remove, size: 15),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text(
                  "$count",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
