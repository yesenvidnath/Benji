import 'package:shared_preferences/shared_preferences.dart';
import '../api/user_service.dart';
// import '../../controllers/user_controller.dart';

class UserRepository {
  final UserService _userService = UserService();

  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    final data = await _userService.getMyProfile(token);

    // Extract and return only relevant data
    return {
      "fullName": "${data['user']['first_name']} ${data['user']['last_name']}",
      "profileImage": data['user']['profile_image'],
      "email": data['user']['email'],
      "phoneNumber": data['user']['phone_number'],
      "userType": data['user']['type'],
      "address": data['user']['address'],
    };
  }
}
