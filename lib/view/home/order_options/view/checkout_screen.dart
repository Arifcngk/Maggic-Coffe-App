import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/models/cart_item.dart';
import 'package:maggic_coffe/models/credit_cart.dart';
import 'package:maggic_coffe/services/credit_card_service.dart';
import 'package:maggic_coffe/services/cart_service.dart';
import 'package:maggic_coffe/view/home/order_options/view/add_credit_card_screen.dart';
import 'package:maggic_coffe/view/home/order_options/view/order_confirmation_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/view/home/order_options/widgets/custom_button_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final int branchId;
  final List<CartItem> cartItems;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.branchId,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService _cartService = CartService();
  final CreditCardService _creditCardService = CreditCardService();
  List<CreditCard> _creditCards = [];
  int? _selectedCardId;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cards = await _creditCardService.getCreditCards();
      setState(() {
        _creditCards = cards;
        if (cards.isNotEmpty) {
          _selectedCardId = cards.first.cardId;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Kartlar yüklenemedi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createOrder() async {
    if (_selectedCardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir ödeme kartı seçin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _cartService.createOrder(
        items: widget.cartItems,
        branchId: widget.branchId,
        cardId: _selectedCardId!,
      );

      if (!mounted) return;

      if (response['message'] == 'Sipariş oluşturuldu') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(
              orderId: response['order_id'],
              baristaName: response['barista_name'],
              baristaEmail: response['barista_email'],
            ),
          ),
        );
      } else {
        throw Exception(response['message'] ?? 'Sipariş oluşturulamadı');
      }
    } catch (e) {
      setState(() {
        _error = 'Sipariş oluşturulamadı: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _cartService.getTotalPrice(_cartService.items);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarGlobalWidget(txt: 'Ödeme'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ödeme Kartı',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_creditCards.isEmpty)
                            Center(
                              child: Column(
                                children: [
                                  const Text(
                                      'Kayıtlı kartınız bulunmamaktadır.'),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AddCreditCardScreen(),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadData();
                                      }
                                    },
                                    child: const Text('Yeni Kart Ekle'),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: [
                                ..._creditCards.map((card) => Card(
                                      child: RadioListTile<int>(
                                        title: Text(card.cardTitle),
                                        subtitle: Text(
                                          '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                                        ),
                                        value: card.cardId,
                                        groupValue: _selectedCardId,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCardId = value;
                                          });
                                        },
                                      ),
                                    )),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddCreditCardScreen(),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadData();
                                    }
                                  },
                                  child: const Text('Yeni Kart Ekle'),
                                ),
                              ],
                            ),
                          const SizedBox(height: 32),
                          Text(
                            'Sipariş Özeti',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._cartService.items.map((item) => ListTile(
                                title: Text(item.coffee.coffeeName),
                                subtitle: Text(
                                    '${item.quantity} x ${item.coffee.price} BYN'),
                                trailing: Text(
                                  '${(item.quantity * item.coffee.price).toStringAsFixed(2)} BYN',
                                ),
                              )),
                          const Divider(),
                          ListTile(
                            title: Text(
                              'Toplam',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '${totalPrice.toStringAsFixed(2)} BYN',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  CustomButtonWidget(
                    onPressed: _createOrder,
                    text: "Pay Now",
                  ),
                ],
              ),
            ),
    );
  }
}
