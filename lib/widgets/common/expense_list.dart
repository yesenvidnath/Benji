// widgets/common/expense_list.dart

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class ExpensesList extends StatelessWidget {
  final List<ExpenseItem> expenses;
  
  const ExpensesList({
    Key? key,
    required this.expenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses Listing',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 16),
          for (var expense in expenses) 
            _buildExpenseItem(
              expense.title,
              expense.percentage,
              expense.isIncrease,
            ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(String title, String percentage, bool isIncrease) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color.fromARGB(255, 229, 229, 250),
            child: const Icon(
              Icons.person,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          Row(
            children: [
              Text(
                percentage,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(width: 8),
              Icon(
                isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncrease ? AppColors.error : AppColors.success,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpenseItem {
  final String title;
  final String percentage;
  final bool isIncrease;

  ExpenseItem({
    required this.title,
    required this.percentage,
    required this.isIncrease,
  });
}