import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maggic_coffe/models/coffe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoffeeService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Coffee>> getCoffees() async {
    final prefs = await SharedPreferences.getInstance(); 
    final token = prefs.getString('token');
    print('Token: $token');
    if (token == null) {
      throw Exception('Token bulunamadı');
    }
    final url = Uri.parse('$baseUrl/coffees');
    print('Request URL: $url');
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
      print('Fetched coffees: $data');
      return data.map((json) => Coffee.fromJson(json)).toList();
    } else {
      throw Exception('Kahve verileri alınamadı: ${response.statusCode}');
    }
  }
}
