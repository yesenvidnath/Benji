import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../controllers/meetings_controller.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../../widgets/common/footer_navigator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; 

class Meeting {
  final String mentorName;
  DateTime dateTime;
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final List<Meeting> _meetings = List.generate(
    4,
    (index) => Meeting(
      mentorName: 'Yulisa Meyun',
      dateTime: DateTime(2021, 11, 23),
      price: 1650.00,
      avatarUrl: '',
    ),
  );

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 2 tabs (My Meetups and History)
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }
  Future<void> _initializeData() async {
    final meetingsController = Provider.of<MeetingsController>(context, listen: false);
    await meetingsController.fetchPendingMeetings();
    await meetingsController.fetchIncompletePaidMeetings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _showRescheduleDialog(BuildContext context, Meeting meeting) {
    DateTime selectedDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 400,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                height: 300,
                child: CupertinoDatePicker(
                  initialDateTime: meeting.dateTime,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: false,
                  minuteInterval: 15,
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDateTime = newDateTime;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    color: AppColors.spendingRed,
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    color: AppColors.primary,
                    child: const Text('Confirm'),
                    onPressed: () {
                      setState(() {
                        meeting.dateTime = selectedDateTime;
                      });
                      
                      // close the navigation
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Meeting successfully Re-Scheduled',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                          ),
                          backgroundColor: AppColors.savingsGreen,
                        ),
                      );
                      return;
                      
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              currentRoute: 'meetings',
              userName: 'Meetups',
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
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(text: 'My Meetups'),
                    Tab(text: 'Pending Payment'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<MeetingsController>(
                builder: (context, meetingsController, child) {
                  if (meetingsController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (meetingsController.errorMessage != null) {
                    return Center(
                      child: Text(meetingsController.errorMessage!),
                    );
                  }

                  final meetings = meetingsController.pendingMeetings;

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // My Meetups
                        _buildMeetupsList(
                          isHistory: false,
                          meetings: meetingsController.pendingMeetings,
                        ),
                        // Pending Payment Tab (incompletePaidMeetings only)
                        _buildMeetupsList(
                          isHistory: true,
                          meetings: meetingsController.incompletePaidMeetings
                              .where((meeting) => meeting['meeting_url'] == null)
                              .toList(),
                        ),
                    ],
                  );
                },
              ),
            ),
            const FooterNavigator(currentRoute: 'meetings'),
          ],
        ),
      ),
    );
  }



  Widget _buildMeetupsList({required bool isHistory, required List<Map<String, dynamic>> meetings}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        final startTime = DateTime.parse(meeting['start_time']);
        final endTime = DateTime.parse(meeting['end_time']);
        final meetingUrl = meeting['meeting_url'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.15),
                            AppColors.primary.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.1),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        meeting['professional_name'].substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meeting['professional_name'],
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start: ${DateFormat('MMM dd, yyyy hh:mm a').format(startTime)}\n'
                            'End: ${DateFormat('MMM dd, yyyy hh:mm a').format(endTime)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (meetingUrl != null && !isHistory) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: meetingUrl));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Meeting URL copied to clipboard!',
                                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.copy, size: 16, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Join Meeting',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (meetingUrl == null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Incomplete Payment',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }



  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}