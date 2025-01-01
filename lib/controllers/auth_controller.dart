import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

class AuthController with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool isLoggedIn = false;
  bool isLoading = false;

  AuthController() {
    _checkLoginStatus();
  }

  // Check login status by checking for the token in SharedPreferences
  Future<void> _checkLoginStatus() async {
    String? token = await _authRepository.getToken();
    isLoggedIn = token != null;
    notifyListeners();
  }

  // Login method to manage user login state
  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await _authRepository.login(email, password);
      isLoggedIn = true;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      //print("Login error: $e");
      isLoggedIn = false;
      isLoading = false;
      notifyListeners();
    }
  }

  // Register method to manage user registration state
  Future<void> register(Map<String, dynamic> registrationData) async {
    try {
      isLoading = true;
      notifyListeners();
      await _authRepository.register(registrationData);
      isLoggedIn = true;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      //print("Registration error: $e");
      isLoggedIn = false;
      isLoading = false;
      notifyListeners();
      rethrow; // Rethrow for UI handling
    }
  }

  // Logout method to handle user logout
  Future<void> logout() async {
    await _authRepository.logout();
    isLoggedIn = false;
    notifyListeners();
  }
}




class AuthControllerOld extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  String? _userId;
  String? _error;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userId => _userId;
  String? get error => _error;

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Simulate successful login
      if (email.isNotEmpty && password.isNotEmpty) {
        _isAuthenticated = true;
        _token = 'dummy_token';
        _userId = 'user_123';
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _token = null;
      _userId = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      
      _isAuthenticated = false;
      _token = null;
      _userId = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Check auth status method
  Future<bool> checkAuthStatus() async {
    try {
      
      // This could check local storage for tokens and validate them
      await Future.delayed(const Duration(milliseconds: 500));
      
      return _isAuthenticated;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  // Password reset request
  Future<bool> requestPasswordReset(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      
      await Future.delayed(const Duration(seconds: 1));
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear any error messages
  void clearError() {
    _error = null;
    notifyListeners();
  }
}