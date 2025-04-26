class Coffee {
  final int coffeeId;
  final String coffeeName;
  final String imageUrl;
  final int? volumeMl;
  final bool isHot;
  final double price;
  final int? pointValue;
  final String? intensity; // Yeni alan

  Coffee({
    required this.coffeeId,
    required this.coffeeName,
    required this.imageUrl,
    this.volumeMl,
    required this.isHot,
    required this.price,
    this.pointValue,
    this.intensity,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) {
    print('Coffee fromJson: $json');
    return Coffee(
      coffeeId: json['coffee_id'] as int,
      coffeeName: json['coffee_name'] as String,
      imageUrl: json['image_url'] as String,
      volumeMl: json['volume_ml'] != null ? json['volume_ml'] as int : 250,
      isHot: json['is_hot'] == 1,
      price: double.parse(json['price'].toString()),
      pointValue: json['point_value'] != null ? json['point_value'] as int : 0,
      intensity: json['intensity'] as String? ?? 'light', // Varsayılan light
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'coffee_id': coffeeId,
      'coffee_name': coffeeName,
      'image_url': imageUrl,
      'volume_ml': volumeMl ?? 250,
      'is_hot': isHot,
      'price': price,
      'point_value': pointValue ?? 0,
      'intensity': intensity ?? 'light',
    };
    print('Coffee toJson: $json');
    return json;
  }
}