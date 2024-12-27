import '../api/convert_service.dart';

class ConvertRepository {
  final ConvertService _convertService = ConvertService();

  Future<Map<String, dynamic>> convertToProfessional(Map<String, dynamic> formData) async {
    return await _convertService.convertToProfessional(formData);
  }
}