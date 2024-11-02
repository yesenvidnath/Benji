import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All Notification'),
              Tab(text: 'Unread'),
            ],
            labelStyle: AppTextStyles.bodyLarge,
            unselectedLabelStyle: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            indicatorColor: AppColors.accent,
            dividerColor: Colors.transparent,
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
            isUnread: true,
          ),
        );
      },
      itemCount: 10, // Replace with actual notification count
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildNotificationIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildNotificationText(),
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.time,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: notification.isMoneyReceived 
            ? const Color(0xFFE9E5FF)
            : const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        notification.isMoneyReceived 
            ? Icons.arrow_downward
            : Icons.arrow_upward,
        color: notification.isMoneyReceived
            ? const Color(0xFF7B61FF)
            : const Color(0xFFFF5C5C),
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