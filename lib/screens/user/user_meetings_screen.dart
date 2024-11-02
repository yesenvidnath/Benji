import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';

// Sample Meeting Model (you should import the actual model from data/models/meeting.dart)
class Meeting {
  final String mentorName;
  final DateTime dateTime;
  final double price;
  final String avatarUrl;

  Meeting({
    required this.mentorName,
    required this.dateTime,
    required this.price,
    required this.avatarUrl,
  });
}

class UserMeetingsScreen extends StatefulWidget {
  const UserMeetingsScreen({super.key});

  @override
  State<UserMeetingsScreen> createState() => _UserMeetingsScreenState();
}

class _UserMeetingsScreenState extends State<UserMeetingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample data - Replace with actual data from your model
  final List<Meeting> _meetings = List.generate(
    4,
    (index) => Meeting(
      mentorName: 'Yulisa Meyun',
      dateTime: DateTime(2021, 11, 23),
      price: 1650.00,
      avatarUrl: '', // Add actual avatar URL if available
    ),
  );

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text('Meetups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelStyle: AppTextStyles.bodyLarge,
            unselectedLabelStyle: AppTextStyles.bodyLarge,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'My Meetups'),
              Tab(text: 'History'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMeetupsList(isHistory: false),
                _buildMeetupsList(isHistory: true),
              ],
            ),
          ),
          const FooterNavigator(currentRoute: 'history'),
        ],
      ),
    );
  }

  Widget _buildMeetupsList({required bool isHistory}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _meetings.length,
      itemBuilder: (context, index) {
        final meeting = _meetings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: meeting.avatarUrl.isNotEmpty 
                    ? NetworkImage(meeting.avatarUrl) as ImageProvider
                    : const AssetImage('assets/images/default_avatar.png'),
                ),
                const SizedBox(width: 12),
                // Meeting Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meeting.mentorName,
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tuesday, 23 Nov 2021',
                        style: AppTextStyles.bodyMedium,
                      ),
                      if (!isHistory) const SizedBox(height: 12),
                      if (!isHistory) Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.textPrimary,
                              ),
                              child: const Text('Re-Schedule'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.textPrimary),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs.${meeting.price.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}