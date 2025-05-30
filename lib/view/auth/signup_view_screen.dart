import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/provider/auth_provider.dart';
import 'package:maggic_coffe/view/auth/signin_view_screen.dart';
import 'package:maggic_coffe/view/auth/widget/base_text_widget.dart';
import 'package:provider/provider.dart';

class SignupViewScreen extends StatefulWidget {
  const SignupViewScreen({super.key});

  @override
  State<SignupViewScreen> createState() => _SignupViewScreenState();
}

class _SignupViewScreenState extends State<SignupViewScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future<void> _register() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register(
        username: _userNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt Başarılı, Giriş Yapabilirsiniz")),
      );

      // Kayıt başarılıysa Login ekranına yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninViewScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Consumer<AuthProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseTextWidget(
                            txt1: "Sign up",
                            txt2: "Create an account here",
                          ),
                          const SizedBox(height: 50),
                          if (provider.error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                provider.error!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
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
                                color: const Color(0xFF324A59),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: provider.isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: const Color(0xFF324A59),
                              ),
                              child: provider.isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : const Icon(Icons.arrow_forward_rounded,
                                      size: 30, color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                          _buttomTxt(context),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
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
              fontSize: 16,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SigninViewScreen(),
                ),
              );
            },
            child: Text(
              "Sign in",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF324A59),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextField _userTxtField() {
    return TextField(
      controller: _userNameController,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.person_outline_sharp,
          color: Colors.black,
        ),
        hintText: "Username",
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFC1C7D0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  TextField _phoneTxtField() {
    return TextField(
      controller: _phoneController,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.phone_android_outlined,
          color: Colors.black,
        ),
        hintText: "Mobile Number",
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFC1C7D0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  TextField _emailTxtField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.mail_outline_outlined,
          color: Colors.black,
        ),
        hintText: "E-mail address",
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFC1C7D0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  TextField _passwordTxtField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
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
          color: const Color(0xFFC1C7D0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}