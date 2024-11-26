import 'package:http/http.dart' as http;
//import 'dart:convert';
import '../../core/config/api_endpoints.dart';
import '../repositories/auth_repository.dart';

class UserService {
  final AuthRepository _authRepository = AuthRepository();

  Future<http.Response> getProfile(String userId) async {
    // Retrieve token from SharedPreferences
    String? token = await _authRepository.getToken();
    final response = await http.get(
      Uri.parse("${ApiEndpoints.getProfileById}/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Attach token in header
      },
    );
    return response;
  }
}
