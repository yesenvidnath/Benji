import 'package:flutter/material.dart';
import '../data/repositories/meetings_repository.dart';

class MeetingsController extends ChangeNotifier {
  final MeetingsRepository _meetingsRepository = MeetingsRepository();

  List<Map<String, dynamic>> allProfessionals = [];
  List<String> allProfessionalTypes = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchAllProfessionals() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      allProfessionals = await _meetingsRepository.fetchAllProfessionals();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load professionals: $e";
      notifyListeners();
    }
  }

  Future<void> fetchAllProfessionalTypes() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      allProfessionalTypes = await _meetingsRepository.fetchAllProfessionalTypes();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load professional types: $e";
      notifyListeners();
    }
  }
}
