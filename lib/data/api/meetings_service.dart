import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/api_endpoints.dart';

class MeetingsService {
  Future<List<dynamic>> fetchAllProfessionals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.post(
      Uri.parse(ApiEndpoints.getAllprofessionals),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"] as List<dynamic>;
    } else {
      throw Exception("Failed to load professionals: ${response.statusCode}");
    }
  }

  Future<List<String>> fetchAllProfessionalTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.getAllprofessionalTypes),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data["data"]);
    } else {
      throw Exception("Failed to load professional types: ${response.statusCode}");
    }
  }

  
}
