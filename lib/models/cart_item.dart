import 'package:maggic_coffe/models/coffe.dart';


class CartItem {
  final Coffee coffee;
  int quantity;
  final bool isTakeaway; // Yeni alan

  CartItem({
    required this.coffee,
    required this.quantity,
    required this.isTakeaway,
  });

  double get totalPrice => coffee.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      coffee: Coffee.fromJson(json['coffee']),
      quantity: json['quantity'] as int,
      isTakeaway: json['is_takeaway'] as bool? ?? false, // Varsayılan false
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'coffee': coffee.toJson(),
      'quantity': quantity,
      'is_takeaway': isTakeaway,
    };
    print('CartItem toJson: $json');
    return json;
  }

  @override
  String toString() {
    return 'CartItem(coffee: ${coffee.toJson()}, quantity: $quantity, is_takeaway: $isTakeaway)';
  }
}