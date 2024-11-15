import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../../screens/user/change_profile_screen.dart';
import '../../../screens/professional/certificate_management.dart';


class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const CustomBottomSheet({
    Key? key,
    required this.title,
    required this.content,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.75,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  child: content,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showModalContent(BuildContext context, String title, Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) => CustomBottomSheet(
        title: title,
        content: content,
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String screen) {
    switch (screen) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChangeProfileScreen(),
          ),
        );
        break;
      case 'about':
        _showAboutSection(context);
        break;

      case 'become_professional':
        _showProfessionalInfo(context);
        break;  
      case 'history':
        _showAppHistory(context);
        break;
      case 'theme':
        _showThemeSettings(context);
        break;
      case 'security':
        _showSecuritySettings(context);
        break;
      case 'notifications':
        _showNotificationSettings(context);
        break;
      case 'personal_id':
        _showPersonalID(context);
        break;
    }
  }

  void _showAboutSection(BuildContext context) {
    _showModalContent(
      context,
      'About',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('App Version'),
            const SizedBox(height: 8),
            const Text('1.0.0', style: AppTextStyles.bodyLarge),
            const SizedBox(height: 24),
            _buildSectionTitle('Description'),
            const SizedBox(height: 8),
            const Text(
              'Your app description goes here. This is a detailed explanation of what your app does and its main features.',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Developer'),
            const SizedBox(height: 8),
            const Text('Your Company Name', style: AppTextStyles.bodyLarge),
            const SizedBox(height: 24),
            _buildSectionTitle('Contact'),
            const SizedBox(height: 8),
            const Text('support@yourapp.com', style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }

  void _showProfessionalInfo(BuildContext context) {
    _showModalContent(
      context,
      'Become a Professional',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join Our Professional Network',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Becoming a professional user gives you access to:',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint('Advanced features and tools'),
                  _buildBulletPoint('Priority customer support'),
                  _buildBulletPoint('Professional certification'),
                  _buildBulletPoint('Exclusive networking opportunities'),
                  _buildBulletPoint('Higher visibility in search results'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Requirements:',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Valid professional credentials'),
            _buildBulletPoint('Minimum 2 years of experience'),
            _buildBulletPoint('Complete our certification process'),
            _buildBulletPoint('Agree to our professional guidelines'),
            const SizedBox(height: 24),
            const Text(
              'By proceeding, you agree to maintain professional standards and comply with our guidelines.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the modal
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CertificationUploadScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Become a Professional',
                style: TextStyle(color: AppColors.buttonText)

              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showAppHistory(BuildContext context) {
    _showModalContent(
      context,
      'App History',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistoryItem(
              date: 'Today, 2:30 PM',
              action: 'Settings Updated',
              description: 'Changed notification preferences',
            ),
            _buildHistoryItem(
              date: 'Yesterday, 4:15 PM',
              action: 'Profile Updated',
              description: 'Modified personal information',
            ),
            _buildHistoryItem(
              date: '2 days ago',
              action: 'Theme Changed',
              description: 'Switched to dark mode',
            ),
            // Add more history items as needed
          ],
        ),
      ),
    );
  }

  void _showThemeSettings(BuildContext context) {
    _showModalContent(
      context,
      'Theme Settings',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeOption(
              title: 'App Theme',
              subtitle: 'Choose between light and dark mode',
              icon: Icons.brightness_6,
              color: AppColors.primary,
              child: CupertinoSlidingSegmentedControl<int>(
                children: const {
                  0: Text('Light'),
                  1: Text('Dark'),
                  2: Text('System'),
                },
                groupValue: 0,
                onValueChanged: (value) {
                  // Implement theme switching logic
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              title: 'Color Scheme',
              subtitle: 'Select your preferred accent color',
              icon: Icons.color_lens,
              color: AppColors.accent,
              child: Wrap(
                spacing: 8,
                children: [
                  _buildColorOption(AppColors.primary),
                  _buildColorOption(AppColors.accent),
                  _buildColorOption(AppColors.success),
                  _buildColorOption(AppColors.warning),
                  _buildColorOption(AppColors.error),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    _showModalContent(
      context,
      'Security Settings',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityOption(
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID',
              icon: Icons.fingerprint,
              value: true,
              onChanged: (value) {},
            ),
            _buildSecurityOption(
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security',
              icon: Icons.security,
              value: false,
              onChanged: (value) {},
            ),
            _buildSecurityOption(
              title: 'App Lock',
              subtitle: 'Lock app when closed',
              icon: Icons.lock,
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    _showModalContent(
      context,
      'Notification Settings',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationOption(
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: true,
              onChanged: (value) {},
            ),
            _buildNotificationOption(
              title: 'Email Notifications',
              subtitle: 'Receive email updates',
              value: false,
              onChanged: (value) {},
            ),
            _buildNotificationOption(
              title: 'Marketing Updates',
              subtitle: 'Receive marketing communications',
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Notification Categories'),
            const SizedBox(height: 16),
            _buildCategoryOption(
              title: 'Security Alerts',
              value: true,
              onChanged: (value) {},
            ),
            _buildCategoryOption(
              title: 'New Features',
              value: true,
              onChanged: (value) {},
            ),
            _buildCategoryOption(
              title: 'Updates',
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  void _showPersonalID(BuildContext context) {
    _showModalContent(
      context,
      'Personal ID',
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User ID',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'ABC-123-XYZ-789',
                          style: AppTextStyles.bodyLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.copy),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'This is your unique identifier in our system. You may need it when contacting support.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }


  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String action,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(action, style: AppTextStyles.bodySmall),
                Text(date, style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodySmall),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }

Widget _buildSecurityOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyLarge),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'settings',
              userName: 'Settings',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  // Profile Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          context,
                          'Profile Information',
                          Icons.person,
                          AppColors.primary,
                          onTap: () => _navigateToScreen(context, 'profile'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // App Settings Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          context,
                          'About',
                          Icons.info,
                          AppColors.accent,
                          onTap: () => _navigateToScreen(context, 'about'),
                        ),
                        _buildDivider(),
                        _buildSettingsItem(
                          context,
                          'Become a Professional',
                          Icons.workspace_premium,
                          AppColors.success,
                          onTap: () => _navigateToScreen(context, 'become_professional'),
                        ),
                        _buildDivider(),
                        _buildSettingsItem(
                          context,
                          'App History',
                          Icons.history,
                          AppColors.success,
                          onTap: () => _navigateToScreen(context, 'history'),
                        ),
                        _buildDivider(),
                        _buildSettingsItem(
                          context,
                          'Theme',
                          Icons.palette,
                          AppColors.warning,
                          onTap: () => _navigateToScreen(context, 'theme'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Security Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          context,
                          'Security',
                          Icons.security,
                          AppColors.error,
                          onTap: () => _navigateToScreen(context, 'security'),
                        ),
                        _buildDivider(),
                        _buildSettingsItem(
                          context,
                          'Notifications',
                          Icons.notifications,
                          AppColors.primary,
                          onTap: () => _navigateToScreen(context, 'notifications'),
                        ),
                        _buildDivider(),
                        _buildSettingsItem(
                          context,
                          'Personal ID',
                          Icons.badge,
                          AppColors.accent,
                          onTap: () => _navigateToScreen(context, 'personal_id'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavigator(currentRoute: 'settings'),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: AppTextStyles.bodyMedium),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.inputBackground,
      indent: 56,
    );
  }
}