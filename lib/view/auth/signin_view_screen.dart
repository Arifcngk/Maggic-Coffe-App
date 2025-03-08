import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/provider/auth_provider.dart';
import 'package:maggic_coffe/view/auth/signup_view_screen.dart';
import 'package:maggic_coffe/view/auth/widget/base_text_widget.dart';
import 'package:provider/provider.dart';

class SigninViewScreen extends StatefulWidget {
  const SigninViewScreen({super.key});

  @override
  State<SigninViewScreen> createState() => _SigninViewScreenState();
}

class _SigninViewScreenState extends State<SigninViewScreen> {
  final _emailControlller = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  // login işlemi yapar
  Future<void> _login() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(
        email: _emailControlller.text,
        password: _passwordController.text,
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

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
              txt1: "Sign in",
              txt2: "Welcome back",
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _emailControlller,
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
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                icon:
                    const Icon(Icons.lock_outline_rounded, color: Colors.black),
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
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Forgot Password?",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  decoration: TextDecoration.underline, // Alt çizgi ekler
                  decorationColor:
                      Colors.black, // Alt çizgi rengini siyah yapar
                  decorationThickness:
                      1.5, // Çizgi kalınlığını ayarlar (isteğe bağlı)
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _login(),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New member?  ",
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
                            builder: (context) => const SignupViewScreen(),
                          ));
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF324A59),
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
