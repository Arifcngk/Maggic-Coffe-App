class CreditCard {
  final int cardId;
  final int userId;
  final String cardTitle;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  CreditCard({
    required this.cardId,
    required this.userId,
    required this.cardTitle,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardId: json['card_id'] as int,
      userId: json['user_id'] as int,
      cardTitle: json['card_title'] as String,
      cardNumber: json['card_number'] as String,
      expiryDate: json['expiry_date'] as String,
      cvv: json['cvv'] as String,
    );
  }

  @override
  String toString() {
    return 'CreditCard(cardId: $cardId, cardTitle: $cardTitle, cardNumber: $cardNumber)';
  }
}