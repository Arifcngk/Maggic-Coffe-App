import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/models/cart_item.dart';
import 'package:maggic_coffe/services/cart_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    setState(() => _isLoading = true);
    try {
      final cartItems = await _cartService.getCart();
      setState(() {
        _cartItems = cartItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sepet yüklenemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _cartService.getTotalPrice(_cartItems);
    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(child: Text('Sepet boş'))
              : ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return ListTile(
                      title: Text(item.coffee.coffeeName),
                      subtitle: Text(
                        'Adet: ${item.quantity} | Fiyat: ${(item.totalPrice).toStringAsFixed(2)} TL | ${item.isTakeaway ? 'Takeaway' : 'Onsite'} | Yoğunluk: ${item.coffee.intensity ?? 'light'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Color(0xFF001833)),
                            onPressed: () async {
                              await _cartService.updateQuantity(
                                item.coffee.coffeeId,
                                item.isTakeaway, // Ekledik
                                item.quantity - 1,
                              );
                              await _fetchCart();
                            },
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add, color: Color(0xFF001833)),
                            onPressed: () async {
                              await _cartService.updateQuantity(
                                item.coffee.coffeeId,
                                item.isTakeaway, // Ekledik
                                item.quantity + 1,
                              );
                              await _fetchCart();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      bottomSheet: SlidingUpPanelWidget(
        panelController: PanelController(),
        cartItems: _cartItems,
        totalPrice: totalPrice,
      ),
    );
  }
}

class SlidingUpPanelWidget extends StatelessWidget {
  final PanelController panelController;
  final List<CartItem> cartItems;
  final double totalPrice;

  const SlidingUpPanelWidget({
    super.key,
    required this.panelController,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      panel: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Toplam: ${totalPrice.toStringAsFixed(2)} TL'),
            const SizedBox(height: 20),
            // TODO: Kart seçimi UI
            ElevatedButton(
              onPressed: () async {
                try {
                  final cartService = CartService();
                  const branchId = 1; // TODO: Şube seçimi
                  const cardId = 1; // TODO: Seçilen kart
                  const token =
                      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwiaWF0IjoxNzQ1NjU2Nzc1LCJleHAiOjE3NDU2NjAzNzV9.36XMdEXHfwuD05-woaWfqJW-fD19meKqziAzsDKiljg';
                  await cartService.createOrder(
                    cartItems: cartItems,
                    branchId: branchId,
                    cardId: cardId,
                    token: token,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderIsConfirmedView()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sipariş başarısız: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001833),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 52),
              ),
              child: Text(
                'Pay Now',
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
}

class OrderIsConfirmedView extends StatelessWidget {
  const OrderIsConfirmedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sipariş Onaylandı')),
      body: const Center(child: Text('Siparişiniz alındı!')),
    );
  }
}