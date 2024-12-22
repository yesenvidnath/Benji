import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import 'package:intl/intl.dart';

class ExpensesList extends StatelessWidget {
  final List<ExpenseItem> expenses;
  final VoidCallback? onAddExpense;
  final Function(ExpenseItem)? onExpenseTap;
  
  const ExpensesList({
    super.key,
    required this.expenses,
    this.onAddExpense,
    this.onExpenseTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalExpenses = expenses.length;
    final increasingExpenses = expenses.where((e) => e.isIncrease).length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(totalExpenses, increasingExpenses),
        const SizedBox(height: 16),
        _buildExpensesList(),
      ],
    );
  }

  Widget _buildHeader(int total, int increasing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Expenses Listing',
                style: AppTextStyles.profileTitle,
              ),
              if (onAddExpense != null)
                IconButton(
                  onPressed: onAddExpense,
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.accent,
                ),
            ],
          ),
          const SizedBox(height: 8),
        
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.h3.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        indent: 76,
        endIndent: 20,
      ),
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return _buildExpenseItem(expense);
      },
    );
  }

  Widget _buildExpenseItem(ExpenseItem expense) {
    final formattedAmount = expense.amount != null 
        ? NumberFormat.currency(symbol: 'Rs').format(expense.amount)
        : expense.percentage;

    return InkWell(
      onTap: onExpenseTap != null ? () => onExpenseTap!(expense) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            _buildCategoryIcon(expense.category),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: AppTextStyles.bodyLarge,
                  ),
                  if (expense.date != null)
                    Text(
                      DateFormat('MMM d, yyyy').format(expense.date!),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      formattedAmount,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: expense.isIncrease ? AppColors.error : AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      expense.isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                      color: expense.isIncrease ? AppColors.error : AppColors.success,
                      size: 16,
                    ),
                  ],
                ),
                if (expense.category != null)
                  Text(
                    expense.category!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String? category) {
    IconData icon;
    Color color;
    
    switch (category?.toLowerCase()) {
      case 'food':
        icon = Icons.restaurant;
        color = AppColors.warning;
        break;
      case 'transport':
        icon = Icons.directions_car;
        color = AppColors.primary;
        break;
      case 'shopping':
        icon = Icons.shopping_bag;
        color = AppColors.accent;
        break;
      case 'bills':
        icon = Icons.receipt;
        color = AppColors.error;
        break;
      default:
        icon = Icons.attach_money;
        color = AppColors.success;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.1),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}

class ExpenseItem {
  final String title;
  final String percentage;
  final bool isIncrease;
  final double? amount;
  final String? category;
  final DateTime? date;

  ExpenseItem({
    required this.title,
    required this.percentage,
    required this.isIncrease,
    this.amount,
    this.category,
    this.date,
  });
}