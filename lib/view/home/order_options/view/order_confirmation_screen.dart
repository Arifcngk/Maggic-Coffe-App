import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/global_widget/tabbar_global_widget.dart';
import 'package:maggic_coffe/view/home/menu/menu_view_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String baristaName;
  final String baristaEmail;
  final int orderId;

  const OrderConfirmationScreen({
    super.key,
    required this.baristaName,
    required this.baristaEmail,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarGlobalWidget(txt: 'Sipariş Onayı'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Siparişiniz Alındı!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF001833),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Siparişiniz hazırlanmaya başlandı',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FB),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Sipariş No',
                      '#$orderId',
                      Icons.receipt_long,
                    ),
                    const Divider(height: 30),
                    _buildInfoRow(
                      'Hazırlayan Barista',
                      baristaName,
                      Icons.person,
                    ),
                    const Divider(height: 30),
                    _buildInfoRow(
                      'Barista E-posta',
                      baristaEmail,
                      Icons.email,
                    ),
                    const Divider(height: 30),
                    _buildInfoRow(
                      'Durum',
                      'Hazırlanıyor',
                      Icons.timer,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF001833).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF001833),
                      size: 24,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Siparişiniz hazır olduğunda bildirim alacaksınız.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF001833),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuViewScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001833),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(200, 52),
                  elevation: 2,
                ),
                child: Text(
                  'Ana Sayfaya Dön',
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
      ),
      bottomNavigationBar: const BottomBarWidget(),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF001833).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF001833),
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF001833),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
