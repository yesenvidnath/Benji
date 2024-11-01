// header_navigator.dart
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../screens/common/expenses_screen.dart';
import '../../../screens/common/notifications_screen.dart';

class HeaderNavigator extends StatelessWidget {
  final String currentRoute;
  final String userName;
  final String? userAvatar;
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onProfilePressed;

  const HeaderNavigator({
    Key? key,
    required this.currentRoute,
    required this.userName,
    this.userAvatar,
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onProfilePressed,
  }) : super(key: key);

  static void _handleNavigation(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer first

    // Handle navigation based on route
    switch (route) {
      case 'expenses':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddExpensesScreen(),
          ),
        );
        break;
      case 'notifications':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ),
        );
        break;
      case 'dashboard':
      case 'history':
      case 'statistics':
      case 'settings':
      case 'help':
        // For screens that aren't implemented yet, show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$route screen is under development'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'logout':
        // Show logout confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Add your logout logic here
                    // For now, just show a snackbar
                    Navigator.pop(context); // Close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logout functionality will be implemented soon'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        break;
    }
  }

  // Static method to build drawer
  static Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.surface,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Menu',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () => _handleNavigation(context, 'dashboard'),
          ),
          _buildDrawerItem(
            icon: Icons.account_balance_wallet,
            title: 'Expenses',
            onTap: () => _handleNavigation(context, 'expenses'),
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () => _handleNavigation(context, 'notifications'),
          ),
          _buildDrawerItem(
            icon: Icons.history,
            title: 'History',
            onTap: () => _handleNavigation(context, 'history'),
          ),
          _buildDrawerItem(
            icon: Icons.show_chart,
            title: 'Statistics',
            onTap: () => _handleNavigation(context, 'statistics'),
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => _handleNavigation(context, 'settings'),
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () => _handleNavigation(context, 'help'),
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => _handleNavigation(context, 'logout'),
          ),
        ],
      ),
    );
  }

  // Rest of the class remains the same...
  static Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryLight),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primaryLight,
        ),
      ),
      onTap: onTap,
    );
  }

  String _getScreenTitle() {
    switch (currentRoute) {
      case 'home':
        return 'Dashboard';
      case 'expenses':
        return 'Expenses';
      case 'notifications':
        return 'Notifications';
      case 'history':
        return 'History';
      case 'statistic':
        return 'Statistics';
      case 'profile':
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build method remains the same...
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - Menu and Title
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: onMenuPressed,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getScreenTitle(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side - Search and Profile
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: onSearchPressed,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onProfilePressed,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.accent.withOpacity(0.1),
                              backgroundImage: userAvatar != null
                                  ? NetworkImage(userAvatar!)
                                  : null,
                              child: userAvatar == null
                                  ? Text(
                                      userName.isNotEmpty
                                          ? userName[0].toUpperCase()
                                          : '?',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.accent,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}