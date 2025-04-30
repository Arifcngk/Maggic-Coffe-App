import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maggic_coffe/models/coffee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoffeeService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Coffee>> getCoffees() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token bulunamadı');
    }

    final url = Uri.parse('$baseUrl/coffees');
    print('Request URL: $url');
    print('Token: $token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('Parsed data: $data');

      return data.map((json) {
        // API'den gelen veriyi Flutter modeline uygun hale getir
        return Coffee(
          coffeeId: json['coffee_id'],
          coffeeName: json['coffee_name'],
          imageUrl: json['image_url'] ?? '',
          price:
              double.parse(json['price'].toString()), // String'i double'a çevir
          pointValue: json['point_value'] ?? 0,
          volumeMl: json['volume_ml'],
          description: json['description'] ?? '',
          intensity: json['intensity'] ?? 'light',
          isAvailable: json['is_available'] ?? true,
          createdAt: DateTime.parse(
              json['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
        );
      }).toList();
    } else {
      throw Exception('Kahve verileri alınamadı: ${response.statusCode}');
    }
  }
}
