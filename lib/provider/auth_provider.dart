import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  User? _user;
  bool get isAuthenticated => _token != null;

  String? get token => _token;
  User? get user => _user;

  // Uygulama açıldığında token'ı kontrol et ve yükle
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      // Kullanıcı bilgilerini API'den almak için bir endpoint varsa burada çağırılabilir
      // Şimdilik sadece token'ı yükleyelim
      print('Token yüklendi: $_token');
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    String? address,
  }) async {
    final result = await _authService.register(
      username: username,
      phone: phone,
      email: email,
      password: password,
      address: address,
    );
    return result;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _authService.login(email: email, password: password);
    if (data['statusCode'] == 200) {
      _token = data['token'];
      _user = User.fromJson(data['user']);
      // Token'ı SharedPreferences'a kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      notifyListeners();
    }
    return data;
  }

  // Çıkış yap ve token'ı sil
  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }
}