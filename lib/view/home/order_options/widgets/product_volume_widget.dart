import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_text_widget.dart';

class ProductVolumeWidget extends StatefulWidget {
  const ProductVolumeWidget({super.key});

  @override
  State<ProductVolumeWidget> createState() => _ProductVolumeWidgetState();
}

class _ProductVolumeWidgetState extends State<ProductVolumeWidget> {
  int selectedVolume = 350; // Seçili olan hacim

  void selectCoffee(int volume) {
    setState(() {
      selectedVolume = volume;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Volume, ml", fontSize: 18),
        Row(
          children: [
            _drinkVolume(iconSize: 24, mlText: "250", extraSpacing: 14),
            const SizedBox(width: 14),
            _drinkVolume(iconSize: 30, mlText: "350", extraSpacing: 7),
            const SizedBox(width: 14),
            _drinkVolume(iconSize: 36, mlText: "450", extraSpacing: 0),
          ],
        ),
      ],
    );
  }

  Widget _drinkVolume({
    required double iconSize,
    required String mlText,
    required double
        extraSpacing, // İkonların farklı boyutlarını dengelemek için
  }) {
    int volume = int.parse(mlText);
    bool isSelected = volume == selectedVolume;

    return Column(
      children: [
        SizedBox(height: extraSpacing), // Hiza düzeltmesi için
        GestureDetector(
          onTap: () => selectCoffee(volume),
          child: Image.asset(
            "assets/img/drink.png",
            width: iconSize,
            color: isSelected ? Colors.black : const Color(0xFFD8D8D8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          mlText,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.black : const Color(0xFFD8D8D8),
          ),
        )
      ],
    );
  }
}
