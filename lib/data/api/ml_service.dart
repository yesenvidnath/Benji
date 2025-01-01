import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/api_endpoints.dart';

class MLService {
  Future<Map<String, dynamic>> fetchConsolidatedData(String token) async {
    final url = Uri.parse(ApiEndpoints.getBotgeneratedInstings);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch consolidated data: ${response.body}');
    }
  }
}
