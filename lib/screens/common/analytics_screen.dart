import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/ml_analytics_graph.dart';
import '../../../widgets/common/ml_expense_list.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../controllers/analytics_controller.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedFilter = 'Yearly';
  final List<String> filterOptions = ['Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    final analyticsController = Provider.of<AnalyticsController>(context, listen: false);
    await analyticsController.fetchConsolidatedData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget _buildAnalyticsContent() {
    return Consumer<AnalyticsController>(
      builder: (context, analyticsController, child) {
        if (analyticsController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (analyticsController.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  analyticsController.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: _initializeData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final expenses = analyticsController.expensesData.map((expense) {
          final amount = double.tryParse(expense["amount"].toString()) ?? 0;
          return ExpenseItem(
            title: expense["title"],
            percentage: "Rs.${expense["amount"]}",
            isIncrease: amount > 0,
          );
        }).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: AppTextStyles.profileTitle,
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) => Container(
                            height: 216,
                            padding: const EdgeInsets.only(top: 6.0),
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            color: CupertinoColors.systemBackground.resolveFrom(context),
                            child: SafeArea(
                              top: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CupertinoButton(
                                        child: Text(
                                          'Cancel',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.spendingRed,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      CupertinoButton(
                                        child: Text(
                                          'Done',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.primaryButton,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: 32.0,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: filterOptions.indexOf(selectedFilter),
                                      ),
                                      onSelectedItemChanged: (int selectedItem) {
                                        setState(() {
                                          selectedFilter = filterOptions[selectedItem];
                                        });
                                      },
                                      children: List<Widget>.generate(filterOptions.length, (int index) {
                                        return Center(
                                          child: Text(
                                            filterOptions[index],
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.inputBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedFilter,
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              CupertinoIcons.chevron_down,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MLAnalyticsGraph(selectedFilter: selectedFilter),
              const SizedBox(height: 20),
              MLExpensesList(expenses: expenses),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendationsContent() {
    return Consumer<AnalyticsController>(
      builder: (context, analyticsController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Benji\'s Insight'),
              const SizedBox(height: 16),
              _buildRecommendationCard(
                'Insight',
                analyticsController.forecastingMessage,
                0.0,
                Icons.lightbulb,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Predictions'),
              const SizedBox(height: 16),
              _buildPredictionCard(
                'Prediction',
                analyticsController.insights,
                0.0,
                Icons.trending_up,
              ),
            ],
          ),
        );
      },
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
              currentRoute: 'analytics',
              userName: 'Analytics',
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
                    Tab(text: 'Analytics'),
                    Tab(text: 'Recommendations'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAnalyticsContent(),
                    _buildRecommendationsContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavigator(currentRoute: 'analytics'),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String description, double savings, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface.withOpacity(0.95),
            AppColors.surface.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(String title, String description, double amount, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface.withOpacity(0.95),
            AppColors.surface.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.warning),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
