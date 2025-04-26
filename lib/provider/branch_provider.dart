import 'package:flutter/material.dart';
import 'package:maggic_coffe/services/branch_service.dart';

class BranchProvider with ChangeNotifier {
  List<dynamic> _branches = [];
  dynamic _selectedBranch;

  List<dynamic> get branches => _branches;
  dynamic get selectedBranch => _selectedBranch;

  // Şube seçildiğinde çağrılacak metot
  void selectBranch(dynamic branch) {
    _selectedBranch = branch;
    notifyListeners();
  }

  Future<void> fetchBranches() async {
    try {
      _branches = await BranchService().getBranches();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load branches: $e');
    }
  }
}
