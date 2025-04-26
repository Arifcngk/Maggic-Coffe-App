import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/auth';

  Future<Map<String, dynamic>> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    String? address,
  }) async {
    try {
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

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return {
          'statusCode': response.statusCode,
          'message': data['message'] ?? 'Kullanıcı başarıyla oluşturuldu',
        };
      } else {
        throw Exception(
            data['message'] ?? 'Kayıt başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası (register): $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return data;
      } else {
        throw Exception(
            data['message'] ?? 'Giriş başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası (login): $e');
    }
  }

  Future<User> fetchUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token bulunamadı');
        
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
     

      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.isEmpty) {
          throw Exception('Kullanıcı bilgileri boş döndü');
        }
        return User.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ??
            'Kullanıcı bilgileri alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası (fetchUserInfo): $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    } catch (e) {
      throw Exception('Çıkış hatası: $e');
    }
  }
}
