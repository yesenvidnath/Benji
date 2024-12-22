import 'package:flutter/material.dart';
import '../data/repositories/meetings_repository.dart';

class MeetingsController extends ChangeNotifier {
  final MeetingsRepository _meetingsRepository = MeetingsRepository();

  List<Map<String, dynamic>> allProfessionals = [];
  List<String> allProfessionalTypes = [];
  List<Map<String, dynamic>> pendingMeetings = [];
  List<Map<String, dynamic>> incompletePaidMeetings = [];

  bool isLoading = false;
  String? errorMessage;

  bool isBooking = false;
  String? bookingErrorMessage;
  Map<String, dynamic>? bookingResponse;

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

  Future<void> bookMeeting(int professionalId, String startTime) async {
    isLoading = true;
    notifyListeners();

    try {
      bookingResponse = await _meetingsRepository.bookMeeting(professionalId, startTime);
    } catch (e) {
      print("Error in MeetingsController.bookMeeting: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPendingMeetings() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      pendingMeetings = await _meetingsRepository.fetchPendingMeetings();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load pending meetings: $e";
      notifyListeners();
    }
  }

  Future<void> fetchIncompletePaidMeetings() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      incompletePaidMeetings = await _meetingsRepository.fetchIncompletePaidMeetings();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load incomplete paid meetings: $e";
      notifyListeners();
    }
  }
}
