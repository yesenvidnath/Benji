import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../screens/common/expenses_screen.dart';
import '../../../screens/common/notifications_screen.dart';
import '../../../screens/common/analytics_screen.dart';
import '../../../screens/user/professional_list_screen.dart';
import '../../../screens/user/user_meetings_screen.dart';

class HeaderNavigator extends StatelessWidget {
  final String currentRoute;
  final String userName;
  final String? userAvatar;
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onProfilePressed;

  const HeaderNavigator({
    super.key,
    required this.currentRoute,
    required this.userName,
    this.userAvatar,
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onProfilePressed,
  });

  static void _handleNavigation(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer first

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
            builder: (context) => NotificationScreen(),
          ),
        );
        break;
      case 'meetings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserMeetingsScreen(),
          ),
        );
        break;
      case 'dashboard':
      case 'history':
      case 'statistics':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AnalyticsScreen(),
          ),
        );
        break;
      case 'Profeshanals':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfessionalListScreen(),
          ),
        );
        break;
      case 'settings':
      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$route screen is under development'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
      case 'logout':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Confirm Logout',
                style: AppTextStyles.h3,
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: AppTextStyles.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Logout functionality will be implemented soon'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
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

  static Drawer buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, 0, 0)..scale(1.02),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
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
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white.withOpacity(0.8), Colors.white],
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.surface,
                      child: Icon(
                        CupertinoIcons.person_fill,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Menu',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.chart_bar_fill,
              title: 'Dashboard',
              onTap: () => _handleNavigation(context, 'dashboard'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.money_dollar_circle_fill,
              title: 'Expenses',
              onTap: () => _handleNavigation(context, 'expenses'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.bell_fill,
              title: 'Notifications',
              onTap: () => _handleNavigation(context, 'notifications'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.calendar,
              title: 'Meetings',
              onTap: () => _handleNavigation(context, 'meetings'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.clock_fill,
              title: 'History',
              onTap: () => _handleNavigation(context, 'history'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.graph_circle_fill,
              title: 'Statistics',
              onTap: () => _handleNavigation(context, 'statistics'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: AppColors.inputBorder,
                height: 32,
              ),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.person_2_fill,
              title: 'Professionals',
              onTap: () => _handleNavigation(context, 'Profeshanals'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.settings_solid,
              title: 'Settings',
              onTap: () => _handleNavigation(context, 'settings'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.question_circle_fill,
              title: 'Help & Support',
              onTap: () => _handleNavigation(context, 'help'),
            ),
            _buildDrawerItem(
              icon: CupertinoIcons.square_arrow_left_fill,
              title: 'Logout',
              onTap: () => _handleNavigation(context, 'logout'),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
        size: 22,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: AppColors.primary.withOpacity(0.05),
      selectedTileColor: AppColors.primary.withOpacity(0.1),
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

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.08),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: AppColors.primary.withOpacity(0.9),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.98),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 2),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildIconButton(
                      icon: CupertinoIcons.bars,
                      onPressed: onMenuPressed,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getScreenTitle(),
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildIconButton(
                    icon: CupertinoIcons.search,
                    onPressed: onSearchPressed,
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onProfilePressed,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.9),
                            AppColors.primaryLight,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        backgroundImage: userAvatar != null
                            ? NetworkImage(userAvatar!)
                            : null,
                        child: userAvatar == null
                            ? Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : '?',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : null,
                      ),
                    ),
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
