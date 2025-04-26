import 'package:flutter/material.dart';
import 'package:maggic_coffe/models/coffe.dart';
import 'package:maggic_coffe/models/credit_cart.dart';

class OrderIsConfirmedView extends StatelessWidget {
  final Coffee coffee;
  final int count;
  final double totalPrice;
  final CreditCard selectedCard;

  const OrderIsConfirmedView({
    super.key,
    required this.coffee,
    required this.count,
    required this.totalPrice,
    required this.selectedCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sipariş Onaylandı')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Siparişiniz alındı!', style: const TextStyle(fontSize: 24)),
            Text('Kahve: ${coffee.coffeeName}'),
            Text('Miktar: $count'),
            Text('Toplam: BYN ${totalPrice.toStringAsFixed(2)}'),
            Text('Ödeme: ${selectedCard.cardTitle} (**** ${selectedCard.cardNumber.substring(12)})'),
          ],
        ),
      ),
    );
  }
}