import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl =
      'http://10.0.2.2:8000/api/auth'; // Emülatör için

      
  Future<Map<String, dynamic>> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    String? address,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
        'address': address,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'statusCode': response.statusCode,
      'message': data['message'] ?? 'Bilinmeyen hata',
    };
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Giriş başarısız');
    }
  }
}
