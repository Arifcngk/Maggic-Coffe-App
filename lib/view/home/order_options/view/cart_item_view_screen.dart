import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';
import 'package:maggic_coffe/models/cart_item.dart';
import 'package:maggic_coffe/services/cart_service.dart';
import 'package:maggic_coffe/services/branch_service.dart';
import 'package:maggic_coffe/view/home/order_options/view/checkout_screen.dart';

class CartItemViewScreen extends StatefulWidget {
  const CartItemViewScreen({super.key});

  @override
  State<CartItemViewScreen> createState() => _CartItemViewScreenState();
}

class _CartItemViewScreenState extends State<CartItemViewScreen> {
  final CartService _cartService = CartService();
  final BranchService _branchService = BranchService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  bool _isBranchLoading = true;
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    print('CartScreen: initState çağrıldı');
    _fetchCart();
    _getSelectedBranch();
  }

  Future<void> _getSelectedBranch() async {
    try {
      final branch = await BranchService().getSelectedBranch();
      setState(() {
        _selectedBranchId = branch?['branch_id'];
        _isBranchLoading = false;
      });
    } catch (e) {
      print('Error getting selected branch: $e');
      setState(() {
        _isBranchLoading = false;
      });
    }
  }

  Future<void> _fetchCart() async {
    print('CartScreen: _fetchCart çağrıldı');
    setState(() {
      _isLoading = true;
    });

    try {
      _cartItems = await _cartService.getCart();
      print('CartScreen: Sepet yüklendi: $_cartItems');
    } catch (e) {
      print('CartScreen: Sepet yüklenirken hata: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        item.quantity = newQuantity;
      });
    } else {
      _removeItem(item);
    }
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartService.removeItem(item);
      _cartItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('CartScreen: build çağrıldı, _cartItems: $_cartItems');
    return Scaffold(
      appBar: AppbarGlobalWidget(txt: 'Sepetim'),
      body: _isLoading || _isBranchLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Sepetiniz boş',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Image.network(
                                item.coffee.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item.coffee.coffeeName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${item.volumeMl}ml'),
                                  Text(
                                      '${item.isTakeaway ? 'Paket' : 'Mekan'} - ${item.intensity}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _updateQuantity(
                                        item, item.quantity - 1),
                                  ),
                                  Text('${item.quantity}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => _updateQuantity(
                                        item, item.quantity + 1),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _removeItem(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Toplam',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_cartService.getTotalPrice(_cartItems).toStringAsFixed(2)} TL',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _selectedBranchId == null
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutScreen(
                                          branchId: _selectedBranchId!,
                                          cartItems: _cartItems,
                                          totalPrice: _cartService
                                              .getTotalPrice(_cartItems),
                                        ),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF001833),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(
                              _selectedBranchId == null
                                  ? 'Şube bilgisi yükleniyor...'
                                  : 'Ödemeye Geç',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
