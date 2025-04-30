import 'coffee.dart';

class CartItem {
  final Coffee coffee;
  int quantity;
  final int volumeMl;
  final bool isTakeaway;
  final String intensity;

  CartItem({
    required this.coffee,
    required this.quantity,
    required this.volumeMl,
    required this.isTakeaway,
    this.intensity = 'light',
  });

  double get totalPrice => quantity * coffee.price;

  Map<String, dynamic> toJson() {
    return {
      'coffee': coffee.toJson(),
      'quantity': quantity,
      'volume_ml': volumeMl,
      'is_takeaway': isTakeaway,
      'intensity': intensity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      coffee: Coffee.fromJson(json['coffee']),
      quantity: json['quantity'],
      volumeMl: json['volume_ml'],
      isTakeaway: json['is_takeaway'],
      intensity: json['intensity'] ?? 'light',
    );
  }

  @override
  String toString() {
    return 'CartItem(coffee: ${coffee.toJson()}, quantity: $quantity, volume_ml: $volumeMl, is_takeaway: $isTakeaway, intensity: $intensity)';
  }
}
