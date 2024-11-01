import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../screens/common/add_expenses_screen.dart';

class FooterNavigator extends StatelessWidget {
  final String currentRoute;

  const FooterNavigator({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  void _navigateToScreen(BuildContext context, String route) {
    if (currentRoute != route) {
      switch (route) {
        case 'home':
          // Navigate to home
          // Navigator.pushNamed(context, '/home');
          break;
        case 'expenses':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpensesScreen(),
            ),
          );
          break;
        case 'history':
          // Navigator.pushNamed(context, '/history');
          break;
        case 'statistic':
          // Navigator.pushNamed(context, '/statistic');
          break;
        case 'profile':
          // Navigator.pushNamed(context, '/profile');
          break;
      }
    }
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, String route) {
    final bool isSelected = currentRoute == route;
    return GestureDetector(
      onTap: () => _navigateToScreen(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home, 'Home', 'home'),
              _buildNavItem(context, Icons.history, 'History', 'history'),
              _buildNavItem(context, Icons.account_balance_wallet, 'Expenses', 'expenses'),
              _buildNavItem(context, Icons.show_chart, 'Statistic', 'statistic'),
              _buildNavItem(context, Icons.person, 'Profile', 'profile'),
            ],
          ),
        ),
      ),
    );
  }
}