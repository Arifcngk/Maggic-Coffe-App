import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BranchService {
  static final BranchService _instance = BranchService._internal();
  factory BranchService() => _instance;
  BranchService._internal();

  static const String baseUrl =
      'http://10.0.2.2:8000/api/branches'; // Backend URL
  static const String _selectedBranchKey = 'selected_branch';

  Future<List<dynamic>> getBranches() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // JSON verisini parse et
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load branches');
    }
  }

  Future<Map<String, dynamic>?> getSelectedBranch() async {
    final prefs = await SharedPreferences.getInstance();
    final branchId = prefs.getInt('$_selectedBranchKey.id');
    final branchName = prefs.getString('$_selectedBranchKey.name');
    final branchAddress = prefs.getString('$_selectedBranchKey.address');

    if (branchId == null || branchName == null || branchAddress == null) {
      return null;
    }

    return {
      'branch_id': branchId,
      'branch_name': branchName,
      'branch_address': branchAddress,
    };
  }

  Future<void> setSelectedBranch(Map<String, dynamic> branch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_selectedBranchKey.id', branch['branch_id'] ?? 0);
    await prefs.setString(
        '$_selectedBranchKey.name', branch['branch_name'] ?? '');
    await prefs.setString(
        '$_selectedBranchKey.address', branch['branch_address'] ?? '');
  }

  Future<void> clearSelectedBranch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_selectedBranchKey.id');
    await prefs.remove('$_selectedBranchKey.name');
    await prefs.remove('$_selectedBranchKey.address');
  }
}
