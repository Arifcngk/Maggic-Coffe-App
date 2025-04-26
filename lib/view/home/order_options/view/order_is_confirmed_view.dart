import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/models/cart_item.dart';
import 'package:maggic_coffe/models/credit_cart.dart';

class OrderIsConfirmedView extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalPrice;
  final CreditCard selectedCard;

  const OrderIsConfirmedView({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.selectedCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sipariş Onaylandı',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF001833),
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'Siparişiniz Alındı!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF001833),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return _buildDetailRow(
                    item.coffee.coffeeName,
                    '${item.quantity} x BYN ${item.coffee.price.toStringAsFixed(2)} (${item.coffee.volumeMl} ml)',
                  );
                },
              ),
            ),
            _buildDetailRow('Toplam', 'BYN ${totalPrice.toStringAsFixed(2)}'),
            _buildDetailRow(
              'Ödeme',
              '${selectedCard.cardTitle} (**** ${selectedCard.cardNumber.substring(12)})',
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001833),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(200, 52),
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 97, 99, 107),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
