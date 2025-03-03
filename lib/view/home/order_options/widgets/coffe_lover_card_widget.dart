import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/view/home/order_options/view/coffe_lover_view_screen.dart';

class CoffeLoverCardWidget extends StatefulWidget {
  const CoffeLoverCardWidget({super.key});

  @override
  State<CoffeLoverCardWidget> createState() => _CoffeLoverCardWidgetState();
}

class _CoffeLoverCardWidgetState extends State<CoffeLoverCardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CoffeLoverViewScreen(),
            ));
      },
      child: SizedBox(
        width: 355,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // Köşe yuvarlaklığı
            gradient: const LinearGradient(
              colors: [
                Color(0xFFEEA4CE),
                Color(0xFFC58BF2)
              ], // Gradient renkler
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                offset: Offset(2, 4), // Gölge efekti
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              "Coffe lover assemblage",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            leading: const Icon(FluentIcons.settings_24_regular),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
