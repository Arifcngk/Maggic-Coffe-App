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
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 50,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Siparişiniz Alındı!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
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
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                        'Devam Et',
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
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F8FB),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.credit_card_off,
                                          size: 48,
                                          color: Color(0xFF001833),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Kayıtlı kartınız bulunmamaktadır',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: const Color(0xFF001833),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF001833),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      minimumSize: const Size(200, 52),
                                      elevation: 2,
                                    ),
                                    child: Text(
                                      'Yeni Kart Ekle',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: [
                                ..._creditCards.map((card) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8FB),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _selectedCardId == card.cardId
                                              ? const Color(0xFF001833)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: RadioListTile<int>(
                                        title: Text(
                                          card.cardTitle,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF001833),
                                          ),
                                        ),
                                        subtitle: Text(
                                          '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: const Color(0xFF001833),
                                          ),
                                        ),
                                        value: card.cardId,
                                        groupValue: _selectedCardId,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCardId = value;
                                          });
                                        },
                                        activeColor: const Color(0xFF001833),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF001833),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    minimumSize: const Size(200, 52),
                                    elevation: 2,
                                  ),
                                  child: Text(
                                    'Yeni Kart Ekle',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
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
                          ..._cartService.items.map((item) {
                            double basePrice = item.coffee.price;
                            double volumePrice = 0;

                            if (item.volumeMl == 350) {
                              volumePrice = 10;
                            } else if (item.volumeMl == 450) {
                              volumePrice = 20;
                            }

                            double totalItemPrice =
                                item.quantity * (basePrice + volumePrice);

                            return ListTile(
                              title: Text(item.coffee.coffeeName),
                              subtitle: Text(
                                  '${item.quantity} x ${(basePrice + volumePrice).toStringAsFixed(2)} BYN (${item.volumeMl}ml)'),
                              trailing: Text(
                                '${totalItemPrice.toStringAsFixed(2)} BYN',
                              ),
                            );
                          }),
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
