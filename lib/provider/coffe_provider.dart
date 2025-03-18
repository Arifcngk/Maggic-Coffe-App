import 'package:flutter/material.dart';
import 'package:maggic_coffe/models/coffe_model.dart';
import 'package:maggic_coffe/services/coffe_service.dart';


class CoffeeProvider with ChangeNotifier {
  final CoffeeService _coffeeService = CoffeeService();
  List<CoffeModel> _coffees = [];
  bool _isLoading = false;

  List<CoffeModel> get coffees => _coffees;
  bool get isLoading => _isLoading;

  Future<void> fetchCoffees() async {
    _isLoading = true;
    print('fetchCoffees başladı, isLoading: $_isLoading');
    notifyListeners();

    try {
      _coffees = await _coffeeService.getAllCoffees();
      print('Kahve listesi alındı, uzunluk: ${_coffees.length}');
    } catch (e) {
      print('FetchCoffees hatası: $e');
      _coffees = [];
    } finally {
      _isLoading = false;
      print('fetchCoffees bitti, isLoading: $_isLoading, kahve sayısı: ${_coffees.length}');
      notifyListeners();
    }
  }
}