import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  Future<void> addToCart(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();
    final existingItemIndex = cart.indexWhere(
      (cartItem) => cartItem.coffee.coffeeId == item.coffee.coffeeId && cartItem.isTakeaway == item.isTakeaway,
    );
    if (existingItemIndex != -1) {
      cart[existingItemIndex].quantity += item.quantity;
    } else {
      cart.add(item);
    }
    final cartJson = cart.map((item) => item.toJson()).toList();
    print('Sepete kaydedilen cartJson: $cartJson');
    await prefs.setString(_cartKey, jsonEncode(cartJson));
  }

  Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    if (cartJson == null) return [];
    final List<dynamic> cartData = jsonDecode(cartJson);
    final cartItems = cartData.map((json) => CartItem.fromJson(json)).toList();
    print('Sepetten okunan cartItems: $cartItems');
    return cartItems;
  }

  Future<void> updateQuantity(int coffeeId, bool isTakeaway, int newQuantity) async {
    final cart = await getCart();
    final itemIndex = cart.indexWhere(
      (item) => item.coffee.coffeeId == coffeeId && item.isTakeaway == isTakeaway,
    );
    if (itemIndex != -1) {
      if (newQuantity <= 0) {
        cart.removeAt(itemIndex);
      } else {
        cart[itemIndex].quantity = newQuantity;
      }
      final prefs = await SharedPreferences.getInstance();
      final cartJson = cart.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(cartJson));
    }
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  double getTotalPrice(List<CartItem> cart) {
    return cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> createOrder({
    required List<CartItem> cartItems,
    required int branchId,
    required int? cardId,
    required String token,
  }) async {
    const url = 'http://10.0.2.2:8000/api/orders';
    final totalPrice = getTotalPrice(cartItems);

    final body = {
      'items': cartItems.map((item) {
        return {
          'coffee_id': item.coffee.coffeeId,
          'quantity': item.quantity,
          'unit_price': item.coffee.price,
          'volume_ml': item.coffee.volumeMl ?? 250,
          'is_takeaway': item.isTakeaway,
          'intensity': item.coffee.intensity ?? 'light',
        };
      }).toList(),
      'branch_id': branchId,
      'card_id': cardId,
      'total_price': totalPrice,
    };

    print('Sipariş body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print('Sipariş response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      await clearCart();
    } else {
      throw Exception('Sipariş oluşturulamadı: ${response.body}');
    }
  }
}