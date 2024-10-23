import 'package:get/get.dart';
import 'package:benji/screens/splash/splash_screen.dart';
import 'package:benji/screens/auth/login_screen.dart';
import 'package:benji/screens/auth/register_screen.dart';
import 'package:benji/screens/dashboard/dashboard_screen.dart';
import 'package:benji/screens/transactions/transactions_screen.dart';
import 'package:benji/screens/budget/budget_screen.dart';
import 'package:benji/screens/investments/investments_screen.dart';
import 'package:benji/screens/ai_insights/ai_insights_screen.dart';
import 'package:benji/screens/financial_advice/financial_advice_screen.dart';
import 'package:benji/screens/profile/profile_screen.dart';
class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/dashboard', page: () => DashboardScreen()),
    GetPage(name: '/transactions', page: () => TransactionsScreen()),
    GetPage(name: '/budget', page: () => BudgetScreen()),
    GetPage(name: '/investments', page: () => InvestmentsScreen()),
    GetPage(name: '/ai-insights', page: () => AIInsightsScreen()),
    GetPage(name: '/financial-advice', page: () => FinancialAdviceScreen()),
    GetPage(name: '/profile', page: () => ProfileScreen()),
  ];
}