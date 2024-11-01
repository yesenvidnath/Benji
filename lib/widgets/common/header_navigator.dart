import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class HeaderNavigator extends StatefulWidget {
  final String currentRoute;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HeaderNavigator({
    Key? key,
    required this.currentRoute,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  _HeaderNavigatorState createState() => _HeaderNavigatorState();

  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
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
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.surface,
                  child: Icon(
                    Icons.person,
                    color: AppColors.accent,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'John Doe',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                Text(
                  'john.doe@example.com',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.home,
            label: 'Home',
            route: 'home',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.show_chart,
            label: 'Statistics',
            route: 'statistic',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.notifications,
            label: 'Notifications',
            route: 'notifications',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.account_balance_wallet,
            label: 'Expenses',
            route: 'expenses',
          ),
          const Divider(color: AppColors.inputBorder),
          _buildDrawerItem(
            context: context,
            icon: Icons.settings,
            label: 'Settings',
            route: 'settings',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.help_outline,
            label: 'Help',
            route: 'help',
          ),
        ],
      ),
    );
  }

  static Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(route);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class _HeaderNavigatorState extends State<HeaderNavigator> {
  void _navigateToScreen(BuildContext context, String route) {
    if (widget.currentRoute != route) {
      Navigator.of(context).pushNamed(route);
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: AppColors.accent,
        ),
        onPressed: () {
          widget.scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Text(
        'Expense Tracker',
        style: AppTextStyles.h2.copyWith(
          color: AppColors.accent,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: AppColors.accent,
          ),
          onPressed: () => _navigateToScreen(context, 'profile'),
        ),
      ],
      elevation: 0,
    );
  }
}
