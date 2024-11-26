import 'dart:convert';
import '../api/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  // Handling the business logic for login (auth service)
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _authService.login(email, password);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Storing the token in SharedPreferences
      await _storeToken(responseData['token']);
      return responseData;
    } else {
      throw Exception("Failed to login");
    }
  }

  // Handling the business logic for user registration (auth service)
  Future<void> register(Map<String, dynamic> registrationData) async {
    final response = await _authService.register(registrationData);
    
    // Print full response details for debugging
   // print('Response Status Code: ${response.statusCode}');
    //print('Response Body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) { 
      try {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        // Store the token in SharedPreferences
        await _storeToken(token);
      } catch (e) {
        // Handle JSON parsing errors
        //print('Token parsing error: $e');
        throw Exception('Failed to parse registration response');
      }
    } else {
      // Provide more detailed error information
      throw Exception('Registration failed: ${response.statusCode} - ${response.body}');
    }
  }

  // Handling the business logic for logout (auth service)
  Future<void> logout() async {
    try {
      String? token = await getToken();
      if (token != null) {
        await _authService.logout(token);
      }

      // Remove the token from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      throw Exception("Logout Failed");
    }
  }

  // Store the token in SharedPreferences
  Future<void> _storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Retrieve the token from SharedPreferences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
