import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/common/footer_navigator.dart';  // Add this import

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ExpenseItem> _expenses = [
    ExpenseItem(
      date: DateTime(2024, 1, 13),
      amount: 230.00,
      description: 'Expenses',
    ),
    ExpenseItem(
      date: DateTime(2024, 2, 13),
      amount: -390.00,
      description: 'Expenses',
    ),
    ExpenseItem(
      date: DateTime(2024, 3, 13),
      amount: 121.00,
      description: 'Expenses',
    ),
    ExpenseItem(
      date: DateTime(2024, 4, 13),
      amount: 143.00,
      description: 'Expenses',
    ),
    ExpenseItem(
      date: DateTime(2024, 5, 13),
      amount: -113.00,
      description: 'Expenses',
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedReason;

  // Date formatters
  final DateFormat _fullDateFormat = DateFormat('dd MMMM yyyy');
  final DateFormat _shortDateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
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
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Add'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: Column(  // Wrap the TabBarView in a Column
        children: [
          Expanded(  // Wrap the TabBarView in an Expanded
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAddExpenseTab(),
                _buildExpenseListTab(),
              ],
            ),
          ),
          const FooterNavigator(currentRoute: 'expenses'),  // Add the FooterNavigator here
        ],
      ),
    );
  }

  Widget _buildAddExpenseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date Field
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
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _fullDateFormat.format(_selectedDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reason Dropdown
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: const InputDecoration(
                labelText: 'Reason',
              ),
              items: ['Food', 'Transport', 'Shopping', 'Bills', 'Other']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a reason';
                }
                return null;
              },
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReason = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Add Another Button
            OutlinedButton(
              onPressed: () {
                // Clear form fields
                _amountController.clear();
                _descriptionController.clear();
                setState(() {
                  _selectedReason = null;
                  _selectedDate = DateTime.now();
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Add Another'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Add new expense to the list
                  final newExpense = ExpenseItem(
                    date: _selectedDate,
                    amount: double.parse(_amountController.text),
                    description: _descriptionController.text,
                  );
                  
                  setState(() {
                    _expenses.insert(0, newExpense);
                  });

                  // Clear form and show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Expense added successfully')),
                  );
                  
                  // Switch to the All tab
                  _tabController.animateTo(1);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseListTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter'),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_drop_down),
                label: const Text('Date'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _expenses.length,
            itemBuilder: (context, index) {
              final expense = _expenses[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                ),
                title: Text(
                  _shortDateFormat.format(expense.date),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  expense.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Text(
                  '${expense.amount >= 0 ? '+' : ''}${expense.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: expense.amount >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ExpenseItem {
  final DateTime date;
  final double amount;
  final String description;

  ExpenseItem({
    required this.date,
    required this.amount,
    required this.description,
  });
}