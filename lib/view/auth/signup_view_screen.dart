import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/view/auth/signin_view_screen.dart';
import 'package:maggic_coffe/view/auth/widget/base_text_widget.dart';

class SignupViewScreen extends StatelessWidget {
  const SignupViewScreen({super.key});

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
              txt1: "Sign up",
              txt2: "Create an account here",
            ),
            const SizedBox(height: 50),
            _userTxtField(),
            const SizedBox(height: 30),
            _phoneTxtField(),
            const SizedBox(height: 30),
            _emailTxtField(),
            const SizedBox(height: 30),
            _passwordTxtField(),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "By signing up you agree with our Terms of Use",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: const Color(0xFF324A59)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
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
            const Spacer(),
            _buttomTxt(context)
          ],
        ),
      ),
    );
  }

  Padding _buttomTxt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already a member?  ",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFAAAAAA),
                fontSize: 16),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SigninViewScreen(),
                  ));
            },
            child: Text(
              "Sign in",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF324A59),
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  TextField _userTxtField() {
    return TextField(
      decoration: InputDecoration(
        icon: const Icon(
          Icons.person_outline_sharp,
          color: Colors.black,
        ),
        hintText: "Create an account here",
        hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC1C7D0)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  TextField _phoneTxtField() {
    return TextField(
      decoration: InputDecoration(
        icon: const Icon(
          Icons.phone_android_outlined,
          color: Colors.black,
        ),
        hintText: "Mobile Number",
        hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC1C7D0)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  TextField _emailTxtField() {
    return TextField(
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
    );
  }

  TextField _passwordTxtField() {
    return TextField(
      decoration: InputDecoration(
        icon: const Icon(
          Icons.lock_outline_rounded,
          color: Colors.black,
        ),
        hintText: "Password",
        suffixIcon: const Icon(
          Icons.remove_red_eye_outlined,
          color: Colors.black,
        ),
        hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC1C7D0)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
