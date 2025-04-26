import 'package:flutter/material.dart';
import 'package:maggic_coffe/models/coffe.dart';
import 'package:maggic_coffe/services/coffe_service.dart';


class CoffeeProvider with ChangeNotifier {
  List<Coffee> _coffees = [];
  bool _isLoading = false;
  String? _error;

  List<Coffee> get coffees => _coffees;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final CoffeeService _coffeeService = CoffeeService();

  Future<void> fetchCoffees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _coffees = await _coffeeService.getCoffees();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}