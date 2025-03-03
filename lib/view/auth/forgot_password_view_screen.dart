import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/view/auth/widget/base_text_widget.dart';

class ForgotPasswordViewScreen extends StatelessWidget {
  const ForgotPasswordViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseTextWidget(
                txt1: "Forgot Password?", txt2: "Enter your mail addres"),
            const SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.mail_outline_outlined,
                  color: Colors.black,
                ),
                hintText: "E-mail adress",
                hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFC1C7D0)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), // Butonu tamamen yuvarlak yapar
                  padding: const EdgeInsets.all(20), // Butonun boyutunu ayarlar
                  backgroundColor: const Color(0xFF324A59), // Buton rengi
                ),
                child: const Icon(Icons.arrow_forward_rounded,
                    size: 30, color: Colors.white), // Buton içeriği
              ),
            ),
          ],
        ),
      ),
    );
  }
}
