import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kullanıcı bilgileri
    final name = 'Alex';
    final phone = '+1 123 456 7890';
    final email = 'alex@example.com';
    final address = '123 Coffee St, NY';
    // QR içeriği olarak kullanıcının bilgilerini birleştiriyoruz
    final qrData =
        'Name: $name\nPhone: $phone\nEmail: $email\nAddress: $address';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
          child: Column(
            children: [
              _profileItem(
                icon: Icons.person_2_outlined,
                title: "Name",
                subtitle: "Alex",
              ),
              const SizedBox(height: 15),
              _profileItem(
                icon: Icons.phone_outlined,
                title: "Phone",
                subtitle: "+1 123 456 7890",
              ),
              const SizedBox(height: 15),
              _profileItem(
                icon: Icons.email_outlined,
                title: "Email",
                subtitle: "alex@example.com",
              ),
              const SizedBox(height: 15),
              _profileItem(
                icon: Icons.location_on_outlined,
                title: "Address",
                subtitle: "123 Coffee St, NY",
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 300.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widget method for ListTile
  Widget _profileItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF7F8FB),
        radius: 22,
        child: Icon(
          icon,
          color: const Color(0xFF324A59),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFC1C7D0),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF324A59),
        ),
      ),
      trailing: Image.asset(
        "assets/icon/edit.png",
        width: 26,
        height: 26,
      ),
    );
  }
}
