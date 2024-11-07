import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../screens/common/expenses_screen.dart';
import '../../../screens/common/analytics_screen.dart';
import '../../../screens/common/notifications_screen.dart';

class FooterNavigator extends StatelessWidget {
  final String currentRoute;
  
  const FooterNavigator({
    super.key,
    required this.currentRoute,
  });

  void _navigateToScreen(BuildContext context, String route) {
    if (currentRoute != route) {
      switch (route) {
        case 'home':
          // Navigator.pushNamed(context, '/home');
          break;
        case 'expenses':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensesScreen()),
          );
          break;
        case 'notifications':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
          break;
        case 'analytics':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
          );
          break;
      }
    }
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    {bool isHome = false}
  ) {
    final bool isSelected = currentRoute == route;
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;

    if (isHome) {
      return GestureDetector(
        onTap: () => _navigateToScreen(context, route),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(
            CupertinoIcons.house_fill,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _navigateToScreen(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface.withOpacity(0.95),
            AppColors.surface.withOpacity(0.90),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                CupertinoIcons.graph_square_fill,
                'Analytics',
                'analytics',
              ),
              _buildNavItem(
                context,
                CupertinoIcons.bell_fill,
                'Alerts',
                'notifications',
              ),
              _buildNavItem(
                context,
                CupertinoIcons.house_fill,
                'Home',
                'home',
                isHome: true,
              ),
              _buildNavItem(
                context,
                CupertinoIcons.money_dollar_circle_fill,
                'Expenses',
                'expenses',
              ),
              _buildNavItem(
                context,
                CupertinoIcons.person_fill,
                'Profile',
                'profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}