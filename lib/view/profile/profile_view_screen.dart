import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/provider/auth_provider.dart';
import 'package:maggic_coffe/view/auth/signin_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
                child:
                    Text(provider.error!, style: TextStyle(color: Colors.red)));
          }
          if (provider.user == null) {
            return const Center(child: Text('Kullanıcı bilgileri bulunamadı'));
          }

          final user = provider.user!;
          final qrData =
              'Name: ${user.username}\nPhone: ${user.phone ?? 'Belirtilmemiş'}\nEmail: ${user.email}\nAddress: ${user.address ?? 'Adres belirtilmemiş'}';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
              child: Column(
                children: [
                  _profileItem(
                    icon: Icons.person_2_outlined,
                    title: "Name",
                    subtitle: user.username,
                  ),
                  const SizedBox(height: 15),
                  _profileItem(
                    icon: Icons.phone_outlined,
                    title: "Phone",
                    subtitle: user.phone ?? 'Belirtilmemiş',
                  ),
                  const SizedBox(height: 15),
                  _profileItem(
                    icon: Icons.email_outlined,
                    title: "Email",
                    subtitle: user.email,
                  ),
                  const SizedBox(height: 15),
                  _profileItem(
                    icon: Icons.location_on_outlined,
                    title: "Address",
                    subtitle: user.address ?? 'Adres belirtilmemiş',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 300.0,
                  ),
                  const SizedBox(height: 20), // QR kodu ile buton arası boşluk
                  ElevatedButton(
                    onPressed: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninViewScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF324A59),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Çıkış Yap',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
