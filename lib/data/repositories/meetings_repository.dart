import '../api/meetings_service.dart';

class MeetingsRepository {
  final MeetingsService _meetingsService = MeetingsService();

  Future<List<Map<String, dynamic>>> fetchAllProfessionals() async {
    final rawProfessionals = await _meetingsService.fetchAllProfessionals();
    return rawProfessionals.map((professional) {
      return {
        "user_ID": professional["user_ID"],
        "full_name": professional["full_name"],
        "profile_image": professional["profile_image"],
        "status": professional["status"],
        "type": professional["type"],
        "charge_per_Hr": double.parse(professional["charge_per_Hr"]),
      };
    }).toList();
  }

  Future<List<String>> fetchAllProfessionalTypes() async {
    return await _meetingsService.fetchAllProfessionalTypes();
  }

  Future<Map<String, dynamic>> bookMeeting(int professionalId, String startTime) async {
    try {
      return await _meetingsService.bookMeeting(professionalId, startTime);
    } catch (e) {
      // print("Error in MeetingsRepository.bookMeeting: $e");
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPendingMeetings() async {
    return await _meetingsService.fetchPendingMeetings();
  }

  Future<List<Map<String, dynamic>>> fetchIncompletePaidMeetings() async {
    return await _meetingsService.fetchIncompletePaidMeetings();
  }
}
