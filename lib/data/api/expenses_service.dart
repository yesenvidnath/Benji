// Updated ExpensesService
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/api_endpoints.dart';

class ExpensesService {
  
  Future<Map<String, dynamic>> fetchAllExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.getAllExpensess),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Failed to load expenses data: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> fetchAllReasons() async {
    final response = await http.get(Uri.parse(ApiEndpoints.getAllReasons));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Failed to load reasons data: ${response.statusCode}");
    }
  }

  Future<void> addAllExpenses(List<Map<String, dynamic>> expensesDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.post(
      Uri.parse(ApiEndpoints.addAllExpensess),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"expensesDetails": expensesDetails}),
    );

    // Debugging
    // print("API Response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to save expenses: ${response.statusCode} - ${response.body}");
    }
  }
}
