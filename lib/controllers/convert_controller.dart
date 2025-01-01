import 'package:flutter/material.dart';
import '../data/repositories/convert_repository.dart';
import '../data/models/convert_model.dart';

class ConvertController with ChangeNotifier {
  final ConvertRepository _convertRepository = ConvertRepository();

  bool isLoading = false;
  String? successMessage;
  String? errorMessage;

  Future<void> convertToProfessional(ConvertProfessionalModel model) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final formData = await model.toMultipartFormData(); // Await here
     // print("Controller: Sending data to repository"); // Debug
     // print("Controller Form Data: $formData"); // Debug

      final response = await _convertRepository.convertToProfessional(formData);

      //// print("Controller: Received response: $response"); // Debug

      successMessage = response['message'] ?? "Professional converted successfully.";
    } catch (e) {
      errorMessage = "Failed to convert to professional:";
     // print("Controller Error: $e"); // Debug
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
