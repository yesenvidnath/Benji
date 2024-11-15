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
  final List<ExpenseItem> _savedExpenses = [];

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
    'Freelancing',
    'Health',
    'Education',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

 void _addExpense() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final newExpense = ExpenseItem(
        date: _selectedDate,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text,
        category: _selectedCategory!,
      );
      
      setState(() {
        _pendingExpenses.insert(0, newExpense);
        _clearForm(keepDate: _useSharedDate);
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );
    } else {
      // Show error message if category is not selected
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
      }
    }
  }

  void _clearForm({bool keepDate = false}) {
    _amountController.clear();
    _descriptionController.clear();
    _selectedCategory = null;
    if (!keepDate && !_useSharedDate) {
      setState(() => _selectedDate = DateTime.now());
    }
  }

  void _editExpense(ExpenseItem expense) {
    setState(() {
      _amountController.text = expense.amount.toString();
      _descriptionController.text = expense.description ?? '';
      _selectedCategory = expense.category;
      if (!_useSharedDate) {
        _selectedDate = expense.date;
      }
    });
  }

  void _removeExpense(int index, bool isPending) {
    setState(() {
      if (isPending) {
        _pendingExpenses.removeAt(index);
      } else {
        _savedExpenses.removeAt(index);
      }
    });
  }

  void _saveAllExpenses() {
    if (_pendingExpenses.isNotEmpty) {
      setState(() {
        _savedExpenses.insertAll(0, _pendingExpenses);
        _pendingExpenses.clear();
        _useSharedDate = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All expenses saved successfully!')),
      );
      _tabController.animateTo(1); // Switch to Saved Expenses tab
    }
  }

  Future<void> _showDatePicker() async {
   await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text('Done', style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        if (_useSharedDate) {
                          for (var expense in _pendingExpenses) {
                            expense.date = _selectedDate;
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() => _selectedDate = newDate);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateSelector() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SwitchListTile(
            title: Text(
              'Use shared date for all expenses',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.black87,
              ),
            ),
            value: _useSharedDate,
            activeColor: Colors.blue,
            onChanged: (bool value) {
              setState(() => _useSharedDate = value);
            },
          ),
        ),
        InkWell(
          onTap: _showDatePicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.calendar, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  _dateFormat.format(_selectedDate),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildInputField({
      required Widget child,
      required IconData icon,
    }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(
              icon,
              color: AppColors.primary.withOpacity(0.7),
              size: 22,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildExpenseForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildDateSelector(),
          const SizedBox(height: 16),
          // Amount Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: _amountController,
              style: AppTextStyles.input,
              decoration: InputDecoration(
                prefixIcon: Icon(CupertinoIcons.money_dollar, color: Colors.blue),
                labelText: 'Amount',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.black54,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          // Category Selector
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(CupertinoIcons.tag, color: Colors.blue),
              title: Text(
                _selectedCategory ?? 'Select Category',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _selectedCategory != null ? Colors.black87 : Colors.black54,
                ),
              ),
              trailing: Icon(CupertinoIcons.chevron_down, color: Colors.blue),
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    String? tempCategory = _selectedCategory;
                    return Container(
                      height: 250,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CupertinoButton(
                                child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                                onPressed: () => Navigator.pop(context),
                              ),
                              CupertinoButton(
                                child: Text('Done', style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  setState(() => _selectedCategory = tempCategory);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 32,
                              onSelectedItemChanged: (index) {
                                tempCategory = _categories[index];
                              },
                              children: _categories.map((category) {
                                return Text(
                                  category,
                                  style: TextStyle(color: Colors.black87),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Description Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: _descriptionController,
              style: AppTextStyles.input,
              decoration: InputDecoration(
                prefixIcon: Icon(CupertinoIcons.text_alignleft, color: Colors.blue),
                labelText: 'Description (Optional)',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.black54,
                ),
              ),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 24),
          // Add to List Button
          Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
              child: Text(
                '+ Add to List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_pendingExpenses.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildExpenseList(_pendingExpenses, true),
            const SizedBox(height: 16),
            // Save All Button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveAllExpenses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Save All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpenseList(List<ExpenseItem> expenses, bool isPending) {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No expenses added yet',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '\$',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                expense.category,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                _dateFormat.format(expense.date),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: expense.amount >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isPending) ...[
                    IconButton(
                      icon: Icon(CupertinoIcons.pencil, 
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () => _editExpense(expense),
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.trash, 
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () => _removeExpense(index, isPending),
                    ),
                  ],
                ],
              ),
              onTap: isPending ? () => _editExpense(expense) : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveAllButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _saveAllExpenses,
          child: Center(
            child: Text(
              'Save All',
              style: AppTextStyles.button.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'expenses',
              userName: 'Expenses',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.08),
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
                  labelColor: Colors.blue,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(text: 'Add Expenses'),
                    Tab(text: 'Saved Expenses'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildExpenseForm(),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildExpenseList(_savedExpenses, false),
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
}

class ExpenseItem {
  final double amount;
  final String? description;
  final String category;
  DateTime date;

  ExpenseItem({
    required this.date,
    required this.amount,
    this.description,
    required this.category,
  });
}