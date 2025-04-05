import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF7F8FB),
                radius: 22,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                'Name',
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFC1C7D0)),
              ),
              subtitle: Text(
                'Alex',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF324A59)),
              ),
              trailing: Image.asset(
                "assets/icon/edit.png",
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
