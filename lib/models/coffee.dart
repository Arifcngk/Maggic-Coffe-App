class Coffee {
  final int coffeeId;
  final String coffeeName;
  final String imageUrl;
  final double price;
  final int pointValue;
  final int volumeMl;
  final String description;
  final String intensity;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Coffee({
    required this.coffeeId,
    required this.coffeeName,
    required this.imageUrl,
    required this.price,
    required this.pointValue,
    required this.volumeMl,
    required this.description,
    required this.intensity,
    required this.isAvailable,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'coffee_id': coffeeId,
      'coffee_name': coffeeName,
      'image_url': imageUrl,
      'price': price,
      'point_value': pointValue,
      'volume_ml': volumeMl,
      'description': description,
      'intensity': intensity,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      coffeeId: json['coffee_id'],
      coffeeName: json['coffee_name'],
      imageUrl: json['image_url'],
      price: json['price'].toDouble(),
      pointValue: json['point_value'],
      volumeMl: json['volume_ml'],
      description: json['description'],
      intensity: json['intensity'],
      isAvailable: json['is_available'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Coffee(coffeeId: $coffeeId, coffeeName: $coffeeName, price: $price, pointValue: $pointValue, volumeMl: $volumeMl, intensity: $intensity)';
  }
}
