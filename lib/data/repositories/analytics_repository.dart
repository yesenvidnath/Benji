import '../api/ml_service.dart';

class AnalyticsRepository {
  final MLService _mlService = MLService();

  Future<Map<String, dynamic>> fetchConsolidatedData(String token) async {
    final data = await _mlService.fetchConsolidatedData(token);

    // Process and parse data to ensure correct typing
    final parsedData = {
      "forecastingMessage": data["forecasting_message"] ?? "",
      "insights": data["insights"] ?? "",
      "savingPercentage": double.tryParse(data["saving_percentage"]?.toString() ?? "0") ?? 0.0,
      "spendingPercentage": double.tryParse(data["spending_percentage"]?.toString() ?? "0") ?? 0.0,
      "weeklyChartData": (data["weekly_chart_data"] as List<dynamic>? ?? []).map((entry) {
        return {
          "dayName": entry["day_name"] ?? "",
          "expense": double.tryParse(entry["expense"]?.toString() ?? "0") ?? 0.0,
        };
      }).toList(),
      "monthlyChartData": (data["monthly_chart_data"] as List<dynamic>? ?? []).map((entry) {
        return {
          "weekName": entry["week_name"] ?? "",
          "expense": double.tryParse(entry["expense"]?.toString() ?? "0") ?? 0.0,
        };
      }).toList(),
      "yearlyChartData": (data["yearly_chart_data"] as List<dynamic>? ?? []).map((entry) {
        return {
          "monthName": entry["month_name"] ?? "",
          "expense": double.tryParse(entry["expense"]?.toString() ?? "0") ?? 0.0,
        };
      }).toList(),
      "forecast": {
        "monthlyExpense": double.tryParse(data["forecast"]?["monthly_expense"]?.toString() ?? "0") ?? 0.0,
        "totalExpense": double.tryParse(data["forecast"]?["total_expense"]?.toString() ?? "0") ?? 0.0,
        "totalIncome": double.tryParse(data["forecast"]?["total_income"]?.toString() ?? "0") ?? 0.0,
        "weeklyExpense": double.tryParse(data["forecast"]?["weekly_expense"]?.toString() ?? "0") ?? 0.0,
        "yearlyExpense": double.tryParse(data["forecast"]?["yearly_expense"]?.toString() ?? "0") ?? 0.0,
      },
    };

    // Map expensesData properly
    parsedData["expensesData"] = [
      {
        "title": "Weekly Expense Would Be",
        "amount": double.tryParse(data["forecast"]?["weekly_expense"]?.toString() ?? "0") ?? 0.0,
      },
      {
        "title": "Monthly Expense Would Be",
        "amount": double.tryParse(data["forecast"]?["monthly_expense"]?.toString() ?? "0") ?? 0.0,
      },
      {
        "title": "Yearly Expense Would Be",
        "amount": double.tryParse(data["forecast"]?["yearly_expense"]?.toString() ?? "0") ?? 0.0,
      },

    ];

    return parsedData;
  }
}
