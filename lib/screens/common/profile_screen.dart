import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/analytics_graph.dart';
import '../../../widgets/common/expense_list.dart';
import '../../controllers/user_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final userController = Provider.of<UserController>(context, listen: false);
    if (!userController.isInitialized) {
      await userController.fetchUserProfile();
    }
  }

  void _handleMenuPress() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        if (userController.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.background.withOpacity(0.98),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (userController.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.background.withOpacity(0.98),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userController.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: _initializeData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final expenses = [
          ExpenseItem(title: 'Grocery', percentage: '20%', isIncrease: true),
          ExpenseItem(title: 'Internet', percentage: '5%', isIncrease: true),
          ExpenseItem(title: 'Entertainment', percentage: '25%', isIncrease: false),
          ExpenseItem(title: 'Utilities', percentage: '15%', isIncrease: true),
          ExpenseItem(title: 'Transportation', percentage: '10%', isIncrease: false),
        ];

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background.withOpacity(0.98),
          drawer: HeaderNavigator.buildDrawer(context),
          body: SafeArea(
            child: Column(
              children: [
                HeaderNavigator(
                  currentRoute: 'profile',
                  userName: userController.fullName,
                  onMenuPressed: _handleMenuPress,
                  onSearchPressed: () {},
                  onProfilePressed: () {},
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _initializeData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildProfileInfo(userController),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildGlassStatCard(
                                    'Total Spending',
                                    '\$2,450.80',
                                    CupertinoIcons.money_dollar_circle,
                                    AppColors.spendingRed,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildGlassStatCard(
                                    'Total Savings',
                                    '\$850.20',
                                    CupertinoIcons.briefcase_fill,
                                    AppColors.savingsGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const AnalyticsGraph(),
                          const SizedBox(height: 20),
                          ExpensesList(expenses: expenses),
                          _buildInvestmentsSection(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const FooterNavigator(currentRoute: 'profile'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo(UserController userController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface.withOpacity(0.95),
            AppColors.surface.withOpacity(0.85),
          ],
          stops: const [0.1, 0.9],
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 20,
            offset: const Offset(-5, -5),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          _buildProfileImage(userController),
          const SizedBox(width: 16),
          Expanded(
            child: _buildProfileDetails(userController),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(UserController userController) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 35,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        backgroundImage: userController.profileImage.isNotEmpty
            ? NetworkImage(userController.profileImage)
            : null,
        child: userController.profileImage.isEmpty
            ? const Icon(
                CupertinoIcons.person_alt_circle,
                color: AppColors.primary,
                size: 35,
              )
            : null,
      ),
    );
  }

  Widget _buildProfileDetails(UserController userController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userController.fullName,
          style: AppTextStyles.profileTitle.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.primary.withOpacity(0.12),
                AppColors.primaryLight.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.15),
              width: 0.5,
            ),
          ),
          child: Text(
            userController.userType,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Log out',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
          stops: const [0.1, 0.9],
        ),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 20,
            offset: const Offset(-5, -5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.glassStatTitle.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.glassStatValue.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentsSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Investments',
                style: AppTextStyles.profileTitle,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: AppTextStyles.linkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInvestmentCard(
                  'Stock Market',
                  'Up 8.2%',
                  CupertinoIcons.graph_square,
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInvestmentCard(
                  'Fixed Deposit',
                  'Up 3.5%',
                  CupertinoIcons.lock_shield_fill,
                  true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard(String title, String performance, IconData icon, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primaryLight.withOpacity(0.05),
          ],
          stops: const [0.1, 0.9],
        ),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 20,
            offset: const Offset(-5, -5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.profileSubtitle.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down,
                color: isPositive ? AppColors.success : AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                performance,
                style: AppTextStyles.profileSubtitle.copyWith(
                  color: isPositive ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}