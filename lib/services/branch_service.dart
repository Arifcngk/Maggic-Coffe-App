import 'dart:convert';
import 'package:http/http.dart' as http;

class BranchService {
  static const String baseUrl =
      'http://10.0.2.2:8000/api/branches'; // Backend URL

  Future<List<dynamic>> getBranches() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // JSON verisini parse et
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load branches');
    }
  }
}
