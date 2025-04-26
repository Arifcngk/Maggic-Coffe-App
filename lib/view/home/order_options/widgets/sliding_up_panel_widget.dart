import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/models/coffe.dart';
import 'package:maggic_coffe/models/credit_cart.dart';
import 'package:maggic_coffe/view/home/order_options/view/add_credit_card_screen.dart';
import 'package:maggic_coffe/view/home/order_options/view/order_is_confirmed_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../services/credit_card_service.dart';

class SlidingUpPanelWidget extends StatefulWidget {
  final PanelController panelController;
  final Coffee coffee;
  final int count;
  final double totalPrice;

  const SlidingUpPanelWidget({
    super.key,
    required this.panelController,
    required this.coffee,
    required this.count,
    required this.totalPrice,
  });

  @override
  _SlidingUpPanelWidgetState createState() => _SlidingUpPanelWidgetState();
}

class _SlidingUpPanelWidgetState extends State<SlidingUpPanelWidget> {
  int? _selectedPaymentMethod;
  List<CreditCard> _creditCards = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCreditCards();
  }

  Future<void> _fetchCreditCards() async {
    try {
      final cards = await CreditCardService().getCreditCards();
      print('Fetched cards count: ${cards.length}');
      print('Fetched cards: $cards');
      setState(() {
        _creditCards = cards;
        _isLoading = false;
        if (cards.isNotEmpty) _selectedPaymentMethod = cards[0].cardId;
      });
    } catch (e) {
      print('Fetch cards error: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCard(int cardId) async {
    try {
      await CreditCardService().deleteCreditCard(cardId);
      setState(() {
        _creditCards.removeWhere((card) => card.cardId == cardId);
        if (_creditCards.isEmpty)
          _selectedPaymentMethod = null;
        else
          _selectedPaymentMethod = _creditCards[0].cardId;
      });
    } catch (e) {
      print('Delete card error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kart silinemedi: $e')),
      );
    }
  }

  Future<void> _addNewCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCreditCardScreen(),
      ),
    );
    if (result == true) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      await _fetchCreditCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: widget.panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.4,
      borderRadius: BorderRadius.circular(25),
      panel: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 33),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Payment",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF001833),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addNewCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001833),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text(
                    'Yeni Kart Ekle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Text('Hata: $_error',
                        style: const TextStyle(color: Colors.red))
                    : _creditCards.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Henüz kayıtlı kart yok.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Bu alaana bir resim eklemesi yapacaım
                              ],
                            ),
                          )
                        : _creditCardCustom(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Price",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 97, 99, 107),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.001),
                    Text(
                      "BYN ${widget.totalPrice.toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFF001833)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(165, 52)),
                  ),
                  onPressed: _selectedPaymentMethod == null
                      ? null
                      : () {
                          final selectedCard = _creditCards.firstWhere(
                              (card) => card.cardId == _selectedPaymentMethod);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderIsConfirmedView(
                                coffee: widget.coffee,
                                count: widget.count,
                                totalPrice: widget.totalPrice,
                                selectedCard: selectedCard,
                              ),
                            ),
                          );
                        },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Pay Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _creditCardCustom(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _creditCards.length,
        itemBuilder: (context, index) {
          final card = _creditCards[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF7F8FB),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Radio<int>(
                      activeColor: const Color(0xFF001833),
                      value: card.cardId,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          card.cardTitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.001),
                        Text(
                          '**** **** **** ${card.cardNumber.substring(12)}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: const Color.fromARGB(255, 97, 99, 107),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      card.cardTitle.toLowerCase().contains('visa')
                          ? 'assets/img/visa.png'
                          : 'assets/img/master.png',
                      width: 60,
                      height: 25,
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _deleteCard(card.cardId),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
