import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  User? _user;
  bool get isAuthenticated => _token != null;

  String? get token => _token;
  User? get user => _user;

  Future<void> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    String? address,
  }) async {
    await _authService.register(
      username: username,
      phone: phone,
      email: email,
      password: password,
      address: address,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final data = await _authService.login(email: email, password: password);
    _token = data['token'];
    _user = User.fromJson(data['user']);
    notifyListeners();
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
