import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background.withOpacity(0.98),
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'notifications',
              userName: 'Notifications',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelStyle: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 15,
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  overlayColor: MaterialStateProperty.all(Colors.transparent), // Removes hover color
                  tabs: const [
                    Tab(text: 'All Notifications'),
                    Tab(text: 'Unread'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationList(false),
                  _buildNotificationList(true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavigator(currentRoute: 'notifications'),
    );
  }

  Widget _buildNotificationList(bool unreadOnly) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return _NotificationItem(
          notification: NotificationModel(
            isMoneyReceived: index % 2 == 0,
            name: "Dean Williamson",
            amount: 76.00,
            time: "10:42 AM",
            isUnread: unreadOnly,
          ),
        );
      },
      itemCount: 10,
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            notification.isUnread
                ? AppColors.primary.withOpacity(0.08)
                : AppColors.surface.withOpacity(0.95),
            notification.isUnread
                ? AppColors.primaryLight.withOpacity(0.05)
                : AppColors.surface.withOpacity(0.85),
          ],
          stops: const [0.1, 0.9],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: notification.isUnread
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
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
      ),
      child: Row(
        children: [
          _buildNotificationIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildNotificationText(),
                  style: AppTextStyles.profileSubtitle.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: notification.isUnread ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    notification.time,
                    style: AppTextStyles.glassStatTitle.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (notification.isUnread)
            Container(
              margin: const EdgeInsets.only(left: 12),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    final isReceived = notification.isMoneyReceived;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isReceived ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15),
            isReceived ? AppColors.success.withOpacity(0.05) : AppColors.error.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isReceived ? AppColors.success : AppColors.error).withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isReceived ? AppColors.success : AppColors.error).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        isReceived ? CupertinoIcons.arrow_down : CupertinoIcons.arrow_up,
        color: isReceived ? AppColors.success : AppColors.error,
        size: 24,
      ),
    );
  }

  String _buildNotificationText() {
    final action = notification.isMoneyReceived ? 'received' : 'sent';
    final prefix = notification.isMoneyReceived ? '+' : '-';
    return 'You have $action money from ${notification.name} $prefix\$${notification.amount.toStringAsFixed(2)}';
  }
}

class NotificationModel {
  final bool isMoneyReceived;
  final String name;
  final double amount;
  final String time;
  final bool isUnread;

  NotificationModel({
    required this.isMoneyReceived,
    required this.name,
    required this.amount,
    required this.time,
    required this.isUnread,
  });
}
