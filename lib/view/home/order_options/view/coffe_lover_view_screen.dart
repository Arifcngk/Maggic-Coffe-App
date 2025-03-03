import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_text_widget.dart';

class CoffeLoverViewScreen extends StatefulWidget {
  const CoffeLoverViewScreen({super.key});

  @override
  State<CoffeLoverViewScreen> createState() => _CoffeLoverViewScreenState();
}

class _CoffeLoverViewScreenState extends State<CoffeLoverViewScreen> {
  double _sliderValue = 0.5; // 0 -> Arabic, 1 -> Robusta

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarGlobalWidget(txt: "Coffe lover assemblage"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            _isSelectedBarista(),
            _divider(),
            _coffeType(),
            _divider(),
            _isSelectedCoffeSort(),
            _divider(),
            Row(
              children: [
                textWidget(txt: "Roasting", fontSize: 18),
                Icon(FluentIcons.fire_24_filled)
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _coffeType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: textWidget(txt: "Coffe Type", fontSize: 16),
        ),
        Expanded(
          child: Column(
            children: [
              Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                    //  print(value);
                  });
                },
                min: 0,
                max: 1,
                divisions: 10, // Sadece iki konum var (Arabic & Robusta)
                activeColor: Colors.black,
                inactiveColor: Colors.grey.shade300,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Arabica",
                      style: GoogleFonts.dmSans(color: const Color(0xFFD8D8D8)),
                    ),
                    Text(
                      "Robusta",
                      style: GoogleFonts.dmSans(color: const Color(0xFFD8D8D8)),
                    ),
                  ],
                ),
              ),
            ],
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

  Row _isSelectedBarista() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Select a barista", fontSize: 16),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios_rounded))
      ],
    );
  }

  Row _isSelectedCoffeSort() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Coffe sort", fontSize: 16),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios_rounded))
      ],
    );
  }
}
