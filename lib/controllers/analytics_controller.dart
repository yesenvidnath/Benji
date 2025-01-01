import 'package:flutter/material.dart';
import '../data/repositories/analytics_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsController with ChangeNotifier {
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  String forecastingMessage = "";
  String insights = "";
  double savingPercentage = 0.0;
  double spendingPercentage = 0.0;
  List<Map<String, dynamic>> weeklyChartData = [];
  List<Map<String, dynamic>> monthlyChartData = [];
  List<Map<String, dynamic>> yearlyChartData = [];
  List<Map<String, dynamic>> expensesData = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchConsolidatedData() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("Authentication token is missing.");
      }

      final data = await _analyticsRepository.fetchConsolidatedData(token);

      forecastingMessage = data["forecastingMessage"];
      insights = data["insights"];
      savingPercentage = data["savingPercentage"];
      spendingPercentage = data["spendingPercentage"];
      weeklyChartData = data["weeklyChartData"];
      monthlyChartData = data["monthlyChartData"];
      yearlyChartData = data["yearlyChartData"];
      expensesData = data["expensesData"]; // Ensure this is correctly updated

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load consolidated data: $e";
      notifyListeners();
    }
  }
}
