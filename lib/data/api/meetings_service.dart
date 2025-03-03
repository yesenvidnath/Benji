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

  Future<Map<String, dynamic>> bookMeeting(int professionalId, String startTime) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final uri = Uri.parse(ApiEndpoints.bookMeeting);


    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'professional_id': professionalId,
        'start_time': startTime,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // Log unexpected responses for debugging
      // print("Failed Response: ${response.body}");
      throw Exception("Failed to book meeting: ${response.statusCode}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchPendingMeetings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.getPendingMeetings),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception("Failed to fetch pending meetings: ${response.statusCode}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchIncompletePaidMeetings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.getInocompleatedPaidMeetings),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception(
        "Failed to fetch incomplete paid meetings: ${response.statusCode}",
      );
    }
  }
}
