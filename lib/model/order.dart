class Order {
  final int orderId;
  final int userId;
  final int branchId;
  final int? cardId;
  final int? baristaId;
  final DateTime orderDate;
  final double totalPrice;
  final String status;

  Order({
    required this.orderId,
    required this.userId,
    required this.branchId,
    this.cardId,
    this.baristaId,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] as int,
      userId: json['user_id'] as int,
      branchId: json['branch_id'] as int,
      cardId: json['card_id'] as int?,
      baristaId: json['barista_id'] as int?,
      orderDate: DateTime.parse(json['order_date'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'branch_id': branchId,
      'card_id': cardId,
      'barista_id': baristaId,
      'order_date': orderDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
    };
  }
}
