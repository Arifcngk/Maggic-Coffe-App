import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/models/coffe.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_text_widget.dart';

class ProductRistrettoWidget extends StatefulWidget {
  final Coffee coffee; // Eklendi

  const ProductRistrettoWidget(
      {super.key, required this.coffee}); // Güncellendi

  @override
  State<ProductRistrettoWidget> createState() => _ProductRistrettoWidgetState();
}

class _ProductRistrettoWidgetState extends State<ProductRistrettoWidget> {
  bool isSelected = true; // true = "One", false = "Two"

  void _selected(bool x) {
    setState(() {
      isSelected = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWidget(txt: "Ristretto", fontSize: 18), // Düzeltildi
        Row(
          children: [
            _buildOptionButton("One", true),
            const SizedBox(width: 8),
            _buildOptionButton("Two", false),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionButton(String text, bool value) {
    bool isActive = (isSelected == value);

    return GestureDetector(
      onTap: () => _selected(value),
      child: Container(
        width: 75,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.black : const Color(0xFFD8D8D8),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: isActive ? Colors.black : const Color(0xFFD8D8D8),
            ),
          ),
        ),
      ),
    );
  }
}
