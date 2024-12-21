import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/api_endpoints.dart';

class UserService {
  // Function to get the user's profile using the token
  Future<Map<String, dynamic>> getMyProfile(String token) async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getMyProfile),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch profile: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> getSystemGeneratedInsights(String token) async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getSystemGeneratedInstings),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch insights: ${response.body}");
    }
  }

}
