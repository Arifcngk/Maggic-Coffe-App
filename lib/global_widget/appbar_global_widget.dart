import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarGlobalWidget extends StatelessWidget
    implements PreferredSizeWidget {
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
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF001833),
        ),
        onPressed: () {
          Navigator.pop(context); // Önceki sayfaya geri dön
        },
      ),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 26),
          child: Image.asset(
            "assets/icon/bucket.png",
            width: 26,
            height: 26,
            color: Colors.black,
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
