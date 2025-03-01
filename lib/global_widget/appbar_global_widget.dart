import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarGlobalWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56); // AppBar yüksekliği

  const AppbarGlobalWidget({
    super.key,
    required this.txt,
  });

  final String txt;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: const Icon(
        Icons.arrow_back_ios,
        color: Color(0xFF001833),
      ),
      elevation: 0,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 26),
          child: Icon(
            Icons.shopping_cart_outlined,
            size: 24,
            color: Color(0xFF001833),
          ),
        ),
      ],
      centerTitle: true,
      title: Text(
        txt,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF001833),
        ),
      ),
    );
  }
}
