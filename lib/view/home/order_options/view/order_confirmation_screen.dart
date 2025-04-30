import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/global_widget/tabbar_global_widget.dart';

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
      appBar: AppbarGlobalWidget(txt: 'Sipariş Onayı'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Siparişiniz Başarıyla Oluşturuldu!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Sipariş Detayları',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Sipariş No',
              orderId.toString(),
              Icons.receipt_long,
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              'Hazırlayan Barista',
              baristaName,
              Icons.person,
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              'Barista E-posta',
              baristaEmail,
              Icons.email,
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              'Durum',
              'Hazırlanıyor',
              Icons.timer,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Siparişiniz hazır olduğunda bildirim alacaksınız.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBarWidget(),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF001833),
            size: 24,
          ),
          const SizedBox(width: 15),
          Column(
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
