// Updated ExpensesController
import 'package:flutter/material.dart';
import '../data/repositories/expenses_repository.dart';

class ExpensesController with ChangeNotifier {
  final ExpensesRepository _expensesRepository = ExpensesRepository();

  List<Map<String, dynamic>> allExpenses = [];
  List<Map<String, dynamic>> allReasons = [];

  bool isLoading = false;
  String? errorMessage;

  List<String> get reasons {
    return allReasons.map((reason) => reason['reason'].toString()).toList();
  }

  Future<void> fetchAllExpenses() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      allExpenses = await _expensesRepository.fetchAllExpenseItems();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load expenses data: $e";
      notifyListeners();
    }
  }

  Future<void> fetchAllReasons() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      allReasons = await _expensesRepository.fetchAllReasons();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load reasons data: $e";
      notifyListeners();
    }
  }

  Future<void> addAllExpenses(List<Map<String, dynamic>> expensesDetails) async {
    try {
      await _expensesRepository.addAllExpenses(expensesDetails);
      notifyListeners();
    } catch (error) {
      // print("Error saving expenses: $error"); // Debug log
      rethrow;
    }
  }
}
