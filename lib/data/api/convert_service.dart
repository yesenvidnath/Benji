import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConvertService {
  Future<Map<String, dynamic>> convertToProfessional(Map<String, dynamic> formData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final uri = Uri.parse(ApiEndpoints.convertProfeshnal);

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token';

    formData.forEach((key, value) {
      if (key.contains('certificateImage') && value != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            key,
            value, // Binary data
            filename: 'certificate_${DateTime.now().millisecondsSinceEpoch}.png',
          ),
        );
      } else if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to convert to professional. Status Code: ${response.statusCode}, Response: ${response.body}");
    }
  }
}
