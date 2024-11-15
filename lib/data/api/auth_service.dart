import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/api_endpoints.dart';

class AuthService {
  // Login service implementation
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.loginUser),
      headers: {"Content-Type": "application/json"}, // Corrected to lowercase
      body: jsonEncode({
        "email": email,
        "password": password, // Removed the whitespace
      }),
    );
    return response;
  }

  // Logout service implementation
  Future<http.Response> logout(String token) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.logoutUser),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    return response;
  }
}
