import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('Token: ${_prefs?.getString('token')}'); // Debug için token'ı yazdır
  }

  static String? get token => _prefs?.getString('token');

  static Future<Map<String, String>> _getHeaders() async {
    await init();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ""}',
    };
    print('Headers: $headers'); // Debug için headers'ı yazdır
    return headers;
  }

  // Loyalty Program API'leri
  static Future<Map<String, dynamic>> getUserPoints() async {
    try {
      final url = '$baseUrl/loyalty/points';
      print('Requesting URL: $url'); // Debug için URL'i yazdır
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      print(
          'Response status: ${response.statusCode}'); // Debug için status code'u yazdır
      print(
          'Response body: ${response.body}'); // Debug için response body'yi yazdır

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load points: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserPoints: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getWeeklyOrderCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loyalty/weekly-orders'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weekly orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getWeeklyOrderCount: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getCoffeeHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loyalty/history'),
        headers: await _getHeaders(),
      );

      print('Coffee history response status: ${response.statusCode}');
      print('Coffee history response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed coffee history data: $data');
        return data;
      } else {
        throw Exception(
            'Failed to load coffee history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getCoffeeHistory: $e');
      rethrow;
    }
  }

  // Sipariş API'leri
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required int branchId,
    required int cardId,
    required double totalPrice,
  }) async {
    try {
      // Önce şubedeki baristaları al
      final baristasResponse = await http.get(
        Uri.parse('$baseUrl/branches/$branchId/baristas'),
        headers: await _getHeaders(),
      );

      if (baristasResponse.statusCode != 200) {
        throw Exception('Baristalar alınamadı');
      }

      final List<dynamic> baristas = json.decode(baristasResponse.body);
      if (baristas.isEmpty) {
        throw Exception('Bu şubede barista bulunamadı');
      }

      // Rastgele bir barista seç
      final randomBarista = baristas[Random().nextInt(baristas.length)];

      // Siparişi oluştur
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: await _getHeaders(),
        body: json.encode({
          'items': items,
          'branch_id': branchId,
          'card_id': cardId,
          'total_price': totalPrice,
          'barista_id': randomBarista['barista_id'],
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return {
          'message': 'Sipariş oluşturuldu',
          'order_id': responseData['order_id'],
          'barista_name': randomBarista['barista_name'],
          'barista_email': randomBarista['barista_email'],
        };
      } else {
        throw Exception('Sipariş oluşturulamadı');
      }
    } catch (e) {
      throw Exception('Sipariş oluşturulamadı: $e');
    }
  }

  // Kahve API'leri
  static Future<List<dynamic>> getCoffees() async {
    final response = await http.get(
      Uri.parse('$baseUrl/coffees'),
      headers: await _getHeaders(),
    );
    return json.decode(response.body);
  }

  // Şube API'leri
  static Future<List<dynamic>> getBranches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/branches'),
      headers: await _getHeaders(),
    );
    return json.decode(response.body);
  }

  // Kredi Kartı API'leri
  static Future<List<dynamic>> getCreditCards() async {
    final response = await http.get(
      Uri.parse('$baseUrl/credit-cards'),
      headers: await _getHeaders(),
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> addCreditCard({
    required String cardTitle,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/credit-cards'),
      headers: await _getHeaders(),
      body: json.encode({
        'card_title': cardTitle,
        'card_number': cardNumber,
        'expiry_date': expiryDate,
        'cvv': cvv,
      }),
    );
    return json.decode(response.body);
  }
}
