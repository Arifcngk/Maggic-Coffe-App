class Coffee {
  final int coffeeId;
  final String coffeeName;
  final String imageUrl;
  final int volumeMl;
  final bool isHot;
  final double price;
  final int pointValue;

  Coffee({
    required this.coffeeId,
    required this.coffeeName,
    required this.imageUrl,
    required this.volumeMl,
    required this.isHot,
    required this.price,
    required this.pointValue,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      coffeeId: json['coffee_id'],
      coffeeName: json['coffee_name'],
      imageUrl: json['image_url'],
      volumeMl: json['volume_ml'],
      isHot: json['is_hot'] == 1,
      price: double.parse(json['price'].toString()),
      pointValue: json['point_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coffee_id': coffeeId,
      'coffee_name': coffeeName,
      'image_url': imageUrl,
      'volume_ml': volumeMl,
      'is_hot': isHot,
      'price': price,
      'point_value': pointValue,
    };
  }
}
