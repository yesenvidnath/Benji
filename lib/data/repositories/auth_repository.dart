import 'dart:convert';
import '../api/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Handling the bussness logic for the data processing (login auth service)
  Future<Map<String, dynamic>> login( String email, String password) async{

    final response =  await _authService.login(email, password);

    if (response.statusCode == 200){
      final responseData = jsonDecode(response.body);

      //Storiign the Key within the secure location using the flutter secure storage
      await _secureStorage.write(key:'auth_token', value: responseData['token']);
      return responseData;
    }else{
      throw Exception("Failed to login");
    }

  }

  // Handling the bussness logic for the data processing (log-Out auth service)
  Future<void> logout() async{

    try{
      String? token = await getToken();
      if (token != null){
        await _authService.logout(token);
      }
      await _secureStorage.delete(key: 'auth_token');
    }catch(e){
      throw Exception("Logout Faild");
    }
  }

  Future<String?> getToken() async{
    return await _secureStorage.read(key: 'auth_token');
  }

}