import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../screens/common/expenses_screen.dart';
import '../../../screens/common/login_screen.dart';
import '../../../screens/common/settings_screen.dart';
import '../../../screens/common/notifications_screen.dart';
import '../../../screens/common/analytics_screen.dart';
import '../../../screens/user/professional_list_screen.dart';
import '../../../screens/user/user_meetings_screen.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';

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

  static Future<void> _handleLogout(BuildContext context) async {
    // Get the navigator and auth controller before any UI updates
    final navigator = Navigator.of(context);
    final authController = Provider.of<AuthController>(context, listen: false);

    try {
      // Perform logout
      await authController.logout();
      
      // Navigate to login screen and remove all previous routes
      if (navigator.mounted) {
        await navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    } catch (error) {
      if (!navigator.mounted) return;
      
      // Show error in a way that doesn't depend on scaffold messenger
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout Error'),
            content: Text('Failed to logout: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  static void _handleNavigation(BuildContext context, String route) {
    if (route == 'logout') {
      // Show logout confirmation dialog
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirm Logout',
              style: AppTextStyles.h3,
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: AppTextStyles.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
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
                  // Close both the dialog and the drawer
                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.pop(context); // Close drawer
                  // Handle logout with a slight delay to ensure cleanup
                  Future.microtask(() => _handleLogout(context));
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
      return;
    }

    // Close drawer first
    Navigator.pop(context);

    // Handle other navigation cases with a slight delay
    Future.microtask(() {
      if (!context.mounted) return;
      
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
              builder: (context) => const ProfessionalListScreen(),
            ),
          );
          break;
        case 'settings':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            ),
          );
          break;
        case 'help':
          if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Under Development'),
                content: const Text('This feature is coming soon!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          break;
      }
    });
  }

  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.inputBorder.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.surface,
                      child: Icon(
                        CupertinoIcons.person,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Menu',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu items in scrollable list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerSection(
                    items: [
                      _buildDrawerItem(
                        icon: CupertinoIcons.chart_bar,
                        title: 'Dashboard',
                        onTap: () => _handleNavigation(context, 'dashboard'),
                      ),
                      _buildDrawerItem(
                        icon: CupertinoIcons.money_dollar_circle,
                        title: 'Expenses',
                        onTap: () => _handleNavigation(context, 'expenses'),
                      ),
                      _buildDrawerItem(
                        icon: CupertinoIcons.bell,
                        title: 'Notifications',
                        onTap: () => _handleNavigation(context, 'notifications'),
                      ),
                      _buildDrawerItem(
                        icon: CupertinoIcons.calendar,
                        title: 'Meetings',
                        onTap: () => _handleNavigation(context, 'meetings'),
                      ),
                    ],
                  ),
                  
                  _buildDrawerSection(
                    items: [
                      _buildDrawerItem(
                        icon: CupertinoIcons.graph_circle,
                        title: 'Statistics',
                        onTap: () => _handleNavigation(context, 'statistics'),
                      ),
                      _buildDrawerItem(
                        icon: CupertinoIcons.person_2,
                        title: 'Professionals',
                        onTap: () => _handleNavigation(context, 'Profeshanals'),
                      ),
                    ],
                  ),
                  
                  _buildDrawerSection(
                    items: [
                      _buildDrawerItem(
                        icon: CupertinoIcons.settings,
                        title: 'Settings',
                        onTap: () => _handleNavigation(context, 'settings'),
                      ),
                      _buildDrawerItem(
                        icon: CupertinoIcons.question_circle,
                        title: 'Help & Support',
                        onTap: () => _handleNavigation(context, 'help'),
                      ),
                      _buildDrawerItem(
                        icon: CupertinoIcons.square_arrow_left,
                        title: 'Logout',
                        onTap: () => _handleNavigation(context, 'logout'),
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDrawerSection({required List<Widget> items}) {
    return Column(
      children: [
        ...items,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 32),
        ),
      ],
    );
  }

  static Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary.withOpacity(0.8),
          size: 22,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hoverColor: AppColors.primary.withOpacity(0.05),
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.primary.withOpacity(0.08),
        minLeadingWidth: 24,
        horizontalTitleGap: 12,
      ),
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
