import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maggic_coffe/models/coffe_model.dart';

class CoffeeService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; // Fiziksel cihaz için IP'nizi güncelleyin

  Future<List<CoffeModel>> getAllCoffees() async {
    try {
      print('API isteği yapılıyor: $_baseUrl/coffees');
      final response = await http.get(Uri.parse('$_baseUrl/coffees'));
      print('API yanıtı: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Dönen kahve sayısı: ${data.length}');
        return data.map((json) => CoffeModel.fromJson(json)).toList();
      } else {
        throw Exception('Kahve listesi alınamadı: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
}