import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maggic_coffe/models/credit_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCardService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<CreditCard>> getCreditCards() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: $token');
    if (token == null) throw Exception('Token bulunamadı');

    final url = Uri.parse('$baseUrl/credit_cards');
    print('Request URL: $url');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Get cards status: ${response.statusCode}');
    print('Get cards body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('Parsed data: $data');
      final cards = data.map((json) => CreditCard.fromJson(json)).toList();
      print('Mapped cards: $cards');
      return cards;
    } else {
      throw Exception('Kartlar alınamadı: ${response.statusCode}');
    }
  }

  Future<void> addCreditCard({
    required String cardTitle,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: $token');
    if (token == null) throw Exception('Token bulunamadı');

    final url = Uri.parse('$baseUrl/credit_cards');
    print('Add card URL: $url');
    print('Add card body: ${jsonEncode({
      'card_title': cardTitle,
      'card_number': cardNumber,
      'expiry_date': expiryDate,
      'cvv': cvv,
    })}');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'card_title': cardTitle,
        'card_number': cardNumber,
        'expiry_date': expiryDate,
        'cvv': cvv,
      }),
    );

    print('Add card status: ${response.statusCode}');
    print('Add card response: ${response.body}');
    if (response.statusCode != 201) {
      throw Exception('Kart eklenemedi: ${response.statusCode}');
    }
  }

  Future<void> deleteCreditCard(int cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: $token');
    if (token == null) throw Exception('Token bulunamadı');

    final response = await http.delete(
      Uri.parse('$baseUrl/credit_cards/$cardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Delete card status: ${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception('Kart silinemedi: ${response.statusCode}');
    }
  }
}