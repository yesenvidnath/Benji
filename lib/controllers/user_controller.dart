import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/user_repository.dart';

class UserController with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  
  // User profile fields
  String _fullName = "";
  String _profileImage = "";
  String _email = "";
  String _phoneNumber = "";
  String _userType = "";
  String _address = "";

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get fullName => _fullName;
  String get profileImage => _profileImage;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get userType => _userType;
  String get address => _address;
  bool get isInitialized => _isInitialized;

  Future<void> fetchUserProfile() async {
    if (_isLoading) return; // Prevent multiple simultaneous fetches
    
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("Authentication token is missing.");
      }

      final profileData = await _userRepository.fetchUserProfile(token);

      // Update controller fields
      _fullName = profileData['fullName'];
      _profileImage = profileData['profileImage'];
      _email = profileData['email'];
      _phoneNumber = profileData['phoneNumber'];
      _userType = profileData['userType'];
      _address = profileData['address'];

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Failed to load profile: $e";
      notifyListeners();
    }
  }
}
