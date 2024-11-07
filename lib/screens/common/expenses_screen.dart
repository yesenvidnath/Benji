import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  
  final List<ExpenseItem> _pendingExpenses = [];
  final List<ExpenseItem> _savedExpenses = [
    ExpenseItem(
      date: DateTime(2024, 1, 13),
      amount: 230.00,
      description: 'Grocery Shopping',
      category: 'Food',
    ),
    ExpenseItem(
      date: DateTime(2024, 2, 13),
      amount: -390.00,
      description: 'Monthly Rent',
      category: 'Housing',
    ),
  ];

  // Form Controllers
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  bool _useSharedDate = false;

  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Education',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _handleMenuPress() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _addExpense() {
    if (_formKey.currentState!.validate()) {
      final newExpense = ExpenseItem(
        date: _selectedDate,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text,
        category: _selectedCategory!,
      );
      
      setState(() {
        _pendingExpenses.insert(0, newExpense);
        // Clear form for next entry but keep the date if shared
        _amountController.clear();
        _descriptionController.clear();
        _selectedCategory = null;
      });
    }
  }

  void _saveAllExpenses() {
    if (_pendingExpenses.isNotEmpty) {
      setState(() {
        _savedExpenses.insertAll(0, _pendingExpenses);
        _pendingExpenses.clear();
        // Reset shared date after saving
        _useSharedDate = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All expenses saved successfully!')),
      );
      _tabController.animateTo(1); // Switch to saved expenses tab
    }
  }

  Widget _buildDateSelector() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Use shared date for all expenses'),
          value: _useSharedDate,
          onChanged: (bool value) {
            setState(() => _useSharedDate = value);
          },
          activeColor: AppColors.primary,
        ),
        if (_useSharedDate) 
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                  // Update all pending expenses with new date
                  if (_pendingExpenses.isNotEmpty) {
                    for (var expense in _pendingExpenses) {
                      expense.date = picked;
                    }
                  }
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shared Date:'),
                  Row(
                    children: [
                      Text(_dateFormat.format(_selectedDate)),
                      const SizedBox(width: 8),
                      const Icon(CupertinoIcons.calendar),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExpenseForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(CupertinoIcons.money_dollar),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(CupertinoIcons.tag),
                  ),
                  items: _categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Required' : null,
                  onChanged: (String? newValue) {
                    setState(() => _selectedCategory = newValue);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              prefixIcon: Icon(CupertinoIcons.text_justifyleft),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _addExpense,
            icon: const Icon(Icons.add),
            label: const Text('Add to List'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList(List<ExpenseItem> expenses, bool isPending) {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          isPending ? 'Add some expenses to the list' : 'No saved expenses yet',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(
                CupertinoIcons.money_dollar,
                color: AppColors.primary,
              ),
            ),
            title: Text(expense.description ?? expense.category),
            subtitle: Text('${expense.category} • ${_dateFormat.format(expense.date)}'),
            trailing: Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: AppTextStyles.h3.copyWith(
                color: expense.amount < 0 ? Colors.red : Colors.green,
              ),
            ),
            onLongPress: isPending ? () {
              setState(() {
                expenses.removeAt(index);
              });
            } : null,
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
              currentRoute: 'expenses',
              userName: 'Expenses',
              onMenuPressed: _handleMenuPress,
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Add Expenses'),
                Tab(text: 'Saved Expenses'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Add Expenses Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExpenseForm(),
                        if (_pendingExpenses.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pending Expenses', style: AppTextStyles.h2),
                              ElevatedButton(
                                onPressed: _saveAllExpenses,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                child: const Text('Save All'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildExpenseList(_pendingExpenses, true),
                        ],
                      ],
                    ),
                  ),
                  // Saved Expenses Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saved Expenses', style: AppTextStyles.h2),
                        const SizedBox(height: 16),
                        _buildExpenseList(_savedExpenses, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavigator(currentRoute: 'expenses'),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class ExpenseItem {
  final double amount;
  final String? description;
  final String category;
  DateTime date;  // Made mutable to support shared date updates

  ExpenseItem({
    required this.date,
    required this.amount,
    this.description,
    required this.category,
  });
}