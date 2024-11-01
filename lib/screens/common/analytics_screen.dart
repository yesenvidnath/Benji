import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/analytics_graph.dart';
import '../../../widgets/common/expense_list.dart';
import '../../../widgets/common/footer_navigator.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedFilter = 'Yearly';
  final List<String> filterOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  // Sample expense data
  final List<ExpenseItem> expenses = [
    ExpenseItem(
      title: 'Grocery',
      percentage: '20%',
      isIncrease: true,
    ),
    ExpenseItem(
      title: 'Internet',
      percentage: '5%',
      isIncrease: true,
    ),
    ExpenseItem(
      title: 'Entertainment',
      percentage: '25%',
      isIncrease: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter',
                    style: AppTextStyles.bodyLarge,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.inputBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
                      style: AppTextStyles.bodyMedium,
                      underline: Container(),
                      isDense: true,
                      items: filterOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedFilter = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
                
              ),
            ),

            // Analytics Graph
            const AnalyticsGraph(),


            // Expenses List
            ExpensesList(expenses: expenses),

            // Bottom Navigation Bar Space
            const SizedBox(height: 80),

            const FooterNavigator(currentRoute: 'profile'),
          ],
        ),    
      ),
    
    );
  }
}