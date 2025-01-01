// Updated ExpensesRepository
import '../api/expenses_service.dart';

class ExpensesRepository {
  final ExpensesService _expensesService = ExpensesService();

  Future<List<Map<String, dynamic>>> fetchAllExpenseItems() async {
    final rawData = await _expensesService.fetchAllExpenses();
    final data = rawData['data'] as List<dynamic>?;

    if (data == null) {
      throw Exception("Invalid data structure for expenses.");
    }

    final allExpenseItems = <Map<String, dynamic>>[];

    for (var entry in data) {
      final expenseItems = entry['expense_items'] as List<dynamic>? ?? [];
      for (var item in expenseItems) {
        allExpenseItems.add({
          'expenseslist_ID': item['expenseslist_ID'] ?? 'Unknown',
          'reason_ID': item['reason_ID'] ?? 'Unknown',
          'reason': item['reason'] ?? 'Unknown',
          'amount': item['amount'] ?? '0.00',
          'description': item['description'] ?? '',
          'created_at': item['created_at'] ?? 'Unknown',
          'updated_at': item['updated_at'] ?? 'Unknown',
        });
      }
    }

    return allExpenseItems;
  }

  Future<List<Map<String, dynamic>>> fetchAllReasons() async {
    final data = await _expensesService.fetchAllReasons();

    return (data["data"] as List<dynamic>).map((reason) {
      return Map<String, dynamic>.from(reason);
    }).toList();
  }

  Future<void> addAllExpenses(List<Map<String, dynamic>> expensesDetails) async {
    await _expensesService.addAllExpenses(expensesDetails);
  }
}