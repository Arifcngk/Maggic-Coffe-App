import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/provider/auth_provider.dart';
import 'package:maggic_coffe/view/profile/profile_view_screen.dart';
import 'package:provider/provider.dart';

class WelcomeUserBarWidget extends StatelessWidget {
  const WelcomeUserBarWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.02,
      left: 0,
      right: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD8D8D8),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "${user?.username ?? 'Kullanıcı'}",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50, right: 10),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent, // Arka plan şeffaf
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileViewScreen(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(
                              8.0), // dokunma alanı biraz büyüsün
                          child: Icon(
                            Icons.person_outline_sharp,
                            size: 26,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      "assets/icon/bucket.png",
                      width: 26,
                      height: 26,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
