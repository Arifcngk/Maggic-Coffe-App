import 'package:flutter/material.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_text_widget.dart';

class ProductRistrettoWidget extends StatelessWidget {
  const ProductRistrettoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Ristretto", fontSize: 18),
        Row(
          children: [
            Container(
              width: 75,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD8D8D8), width: 1.5),
              ),
              child: const Center(child: textWidget(txt: "One", fontSize: 14)),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 75,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD8D8D8), width: 1.5),
              ),
              child: const Center(child: textWidget(txt: "Two", fontSize: 14)),
            ),
          ],
        ),
      ],
    );
  }
}
