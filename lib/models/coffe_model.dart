class CoffeModel {
  final int coffeId;
  final String coffeName;
  final String? imageUrl;
  final int ml;
  final bool isHot;
  final double price;

  CoffeModel({
    required this.coffeId,
    required this.coffeName,
    required this.imageUrl,
    required this.ml,
    required this.isHot,
    required this.price,
  });

  factory CoffeModel.fromJson(Map<String, dynamic> json) {
    return CoffeModel(
      coffeId: json['coffeId'] ?? 0, // Provide default value if null
      coffeName: json['coffeName'] ??
          'Unknown Coffee', // Provide default value if null
      imageUrl: json['imageUrl'], // This can be null, and that's okay
      ml: json['ml'] ?? 0, // Provide default value if null
      isHot: (json['isHot'] ?? 0) == 1, // Ensure it's a boolean
      price: double.tryParse(json['price']?.toString() ?? '0.0') ??
          0.0, // Safely parse price
    );
  }
}
