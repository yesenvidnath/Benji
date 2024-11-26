import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/api_endpoints.dart';

class AuthService {
  // Login service implementation
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.loginUser),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    return response;
  }

  // Registration service implementation
  Future<http.Response> register(Map<String, dynamic> registrationData) async {
    try {
      // Ensure all values are converted to appropriate types
      final sanitizedRegistrationData = _sanitizeRegistrationData(registrationData);

      final response = await http.post(
        Uri.parse(ApiEndpoints.registerUser),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", // Explicitly request JSON response
        },
        body: jsonEncode(sanitizedRegistrationData),
      );

      // Handle different possible response scenarios
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        // Provide more context about the error
        throw Exception("Registration failed with status ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to sanitize and convert registration data
  Map<String, dynamic> _sanitizeRegistrationData(Map<String, dynamic> data) {
    final sanitizedData = Map<String, dynamic>.from(data);

    // Ensure numeric values are properly converted
    if (sanitizedData['incomeSources'] is List) {
      sanitizedData['incomeSources'] = (sanitizedData['incomeSources'] as List).map((source) {
        final sanitizedSource = Map<String, dynamic>.from(source);
        
        // Convert amount to numeric
        if (sanitizedSource['amount'] is String) {
          sanitizedSource['amount'] = double.tryParse(sanitizedSource['amount']) ?? 0.0;
        }
        
        return sanitizedSource;
      }).toList();
    }

    return sanitizedData;
  }


  // Logout service implementation
  Future<http.Response> logout(String token) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.logoutUser),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }
}
