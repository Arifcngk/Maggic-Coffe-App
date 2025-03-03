import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_text_widget.dart';

class OnsiteTakeawayWidget extends StatefulWidget {
  const OnsiteTakeawayWidget({super.key});

  @override
  State<OnsiteTakeawayWidget> createState() => _OnsiteTakeawayWidgetState();
}

class _OnsiteTakeawayWidgetState extends State<OnsiteTakeawayWidget> {
  bool selected = true; // false = Onsite, true = Takeaway

  void selectOption(bool isOnsite) {
    setState(() {
      selected = isOnsite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const textWidget(txt: "Onsite / Takeaway", fontSize: 18),
        Row(
          children: [
            IconButton(
              onPressed: () => selectOption(true), // Onsite seçildi
              icon: Icon(
                FluentIcons.drink_coffee_16_regular,
                size: 30,
                color: selected ? Colors.black : const Color(0xFFD8D8D8),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => selectOption(false), // Takeaway seçildi
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: 30,
                color: selected ? const Color(0xFFD8D8D8) : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
