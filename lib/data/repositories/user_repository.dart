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


  Future<Map<String, dynamic>> fetchSystemGeneratedInsights(String token) async {
    final data = await _userService.getSystemGeneratedInsights(token);

    if (!data.containsKey('category_expenses') || !data.containsKey('spendings_and_savings')) {
      throw Exception("Invalid response structure");
    }

    // Parse category expenses
    List<Map<String, dynamic>> categoryExpenses = (data['category_expenses'] as List).map((expense) {
      return {
        "categoryID": expense['category_ID'],
        "categoryName": expense['category_name'],
        "totalAmount": double.tryParse(expense['total_amount'] ?? '0') ?? 0.0,
      };
    }).toList();

    // Parse amounts and dates
    List<Map<String, dynamic>> amountsAndDates = (data['amounts_and_dates'] as List).map((entry) {
      return {
        "amount": double.tryParse(entry['amount'] ?? '0') ?? 0.0,
        "spendingDate": DateTime.tryParse(entry['spending_date'] ?? ''),
      };
    }).toList();

    // Parse spendings and savings
    Map<String, double> spendingsAndSavings = {
      "totalSpendings": double.tryParse(data['spendings_and_savings']['total_spendings'] ?? '') ?? 0.0,
      "totalIncome": double.tryParse(data['spendings_and_savings']['total_income'] ?? '') ?? 0.0,
      "totalSavings": double.tryParse(data['spendings_and_savings']['total_savings'] ?? '') ?? 0.0,
      "savingsPercentage": double.tryParse(data['spendings_and_savings']['savings_percentage'] ?? '') ?? 0.0,
    };

    return {
      "categoryExpenses": categoryExpenses,
      "amountsAndDates": amountsAndDates,
      "spendingsAndSavings": spendingsAndSavings,
    };
  }
}
