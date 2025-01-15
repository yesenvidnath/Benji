import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import 'profile_screen.dart';

//importing the auth controller 
import '../../controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class IncomeSource {
  final String source;
  final dynamic amount; // Change to dynamic if unsure about type
  final String frequency;
  final String description;

  IncomeSource({
    required this.source,
    required this.amount,
    required this.frequency,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "source_name": source,
      "amount": amount is num ? amount.toString() : amount, // Convert num to string
      "frequency": frequency,
      "description": description,
    };
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _agreedToTerms = false;
  bool _hasMultipleIncomes = false;
  DateTime? _selectedBirthday;
  bool _passwordVisible = false;
  String selectedFrequency = 'monthly';

  // Form Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _incomeSourceController = TextEditingController();
  final _incomeAmountController = TextEditingController();
  final _incomeFrequencyController = TextEditingController();
  final _incomeDescriptionController = TextEditingController();
  final _bankController = TextEditingController();

  final List<IncomeSource> incomeSources = [];



  Widget _buildLogo() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          'images/benji_logo.svg',
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  Widget _buildCustomInputField({
    required String label,
    required Widget child,
    double bottomMargin = 24,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            obscureText: isPassword && !_passwordVisible,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            style: AppTextStyles.input.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.inputHint,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              prefixIcon: Icon(
                icon,
                color: AppColors.primary.withOpacity(0.7),
                size: 22,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: AppColors.primary.withOpacity(0.7),
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  void _showFrequencyPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              setState(() {
              selectedFrequency = index == 0 ? 'monthly'
                  : index == 1 ? 'yearly'
                      : index == 2 ? 'daily' : 'weekly';
                _incomeFrequencyController.text = selectedFrequency;
              });
            },
            children: const [
              Text('Monthly'),
              Text('Yearly'),
              Text('Daily'),
              Text('weekly'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeCard(IncomeSource income) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.attach_money,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  income.source,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  income.frequency,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${income.amount.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showBirthdayPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedBirthday ?? DateTime.now().subtract(const Duration(days: 6570)), // Default to 18 years ago
            maximumDate: DateTime.now().subtract(const Duration(days: 4380)), // Minimum age of 12 years
            minimumDate: DateTime.now().subtract(const Duration(days: 36500)), // Maximum age of 100 years
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedBirthday = newDateTime;
              });
            },
          ),
        ),
      ),
    );
  }
  
  void _addIncomeSource() {
    if (!_hasMultipleIncomes && incomeSources.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enable multiple incomes to add more sources',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_incomeSourceController.text.isEmpty ||
        _incomeAmountController.text.isEmpty || _bankController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      incomeSources.add(
        IncomeSource(
          source: _incomeSourceController.text,
          amount: double.parse(_incomeAmountController.text),
          frequency: _incomeFrequencyController.text,
          description: _incomeDescriptionController.text,
        ),
      );

      // Clear the input fields
      _incomeSourceController.clear();
      _incomeAmountController.clear();
      _incomeDescriptionController.clear();
    });
  }

  Widget _buildStepOne() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 32),
        Column(
          children: [
            Text(
              'BENJI',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create Your Account',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        _buildInputField(
          label: 'First Name',
          hint: 'John',
          icon: CupertinoIcons.person,
          controller: _firstNameController,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        _buildInputField(
          label: 'Last Name',
          hint: 'Doe',
          icon: CupertinoIcons.person,
          controller: _lastNameController,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        _buildInputField(
            label: 'Birthday',
            hint: _selectedBirthday != null 
              ? '${_selectedBirthday!.month}/${_selectedBirthday!.day}/${_selectedBirthday!.year}'
              : 'Select your birthday',
            icon: CupertinoIcons.calendar,
            controller: TextEditingController(
              text: _selectedBirthday != null 
                ? '${_selectedBirthday!.month}/${_selectedBirthday!.day}/${_selectedBirthday!.year}'
                : '',
            ),
          readOnly: true,
          onTap: _showBirthdayPicker,
          validator: (value) => _selectedBirthday == null ? 'Please select your birthday' : null,
        ),
        _buildInputField(
          label: 'Phone Number',
          hint: '+1 234 567 8900',
          icon: CupertinoIcons.phone,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
        ),
        _buildInputField(
          label: 'Home Address',
          hint: '1/2 ABC Town, Sample City',
          icon: CupertinoIcons.house,
          controller: _addressController,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your Adress' : null,
        ),
        _buildInputField(
          label: 'Email Address',
          hint: 'example@gmail.com',
          icon: CupertinoIcons.mail,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
        ),
        _buildInputField(
          label: 'Password',
          hint: '••••••••',
          icon: CupertinoIcons.lock,
          controller: _passwordController,
          isPassword: true,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your password' : null,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          child: Row(
            children: [
              Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: _agreedToTerms,
                  onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(
                'I agree to the Terms and Conditions',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildPrimaryButton(
          text: 'Continue',
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _currentStep = 1);
            }
          },
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Sign In',
                style: AppTextStyles.link.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 32),
        Text(
          'Income Details',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 40),

        // Bank input
        _buildCustomInputField(
          label: 'Bank of Choice',
          child: TextField(
            controller: _bankController,
            decoration: InputDecoration(
              hintText: 'e.g., Sampath, BOC',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              prefixIcon: Icon(
                CupertinoIcons.money_dollar_circle,
                color: AppColors.primary.withOpacity(0.7),
                size: 22,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Income source input
        _buildCustomInputField(
          label: 'Income Source',
          child: TextField(
            controller: _incomeSourceController,
            decoration: InputDecoration(
              hintText: 'e.g., Salary, Business',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              prefixIcon: Icon(
                CupertinoIcons.doc_text,
                color: AppColors.primary.withOpacity(0.7),
                size: 22,
              ),
            ),
          ),
        ),

        // Amount input
        _buildCustomInputField(
          label: 'Amount',
          child: TextField(
            controller: _incomeAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0.00',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              prefixIcon: Text(
                '  \$  ',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),

        _buildCustomInputField(
          label: 'Frequency of Earning',
          child: GestureDetector(
            onTap: _showFrequencyPicker,
            child: AbsorbPointer(
              child: TextField(
                controller: _incomeFrequencyController,
                decoration: InputDecoration(
                  hintText: 'Select frequency',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  prefixIcon: Icon(
                    CupertinoIcons.calendar,
                    color: AppColors.primary.withOpacity(0.7),
                    size: 22,
                  ),
                  suffixIcon: Icon(
                    CupertinoIcons.chevron_down,
                    color: AppColors.primary.withOpacity(0.7),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Description input
        _buildCustomInputField(
          label: 'Description',
          child: TextField(
            controller: _incomeDescriptionController,
            decoration: InputDecoration(
              hintText: 'Add a description',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              prefixIcon: Icon(
                CupertinoIcons.mail,
                color: AppColors.primary.withOpacity(0.7),
                size: 22,
              ),
            ),
          ),
        ),

        // Multiple incomes toggle and Add button
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'Multiple incomes?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _hasMultipleIncomes,
                      onChanged: (value) => setState(() => _hasMultipleIncomes = value),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _addIncomeSource,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '+ Add to List',
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),

        // Income cards section
        if (incomeSources.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: incomeSources.length,
              itemBuilder: (context, index) {
                return _buildIncomeCard(incomeSources[index]);
              },
            ),
          ),
        ],

        const SizedBox(height: 32),
        
        _buildPrimaryButton(
          text: 'Complete Registration',
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              // Create the income sources from the user input
              List<Map<String, dynamic>> incomeSourcesList = [];
              
              for (var incomeSource in incomeSources) {
                incomeSourcesList.add(incomeSource.toJson());
              }

              // Prepare registration data
              Map<String, dynamic> registrationData = {
                "type": "Customer", // Assuming this is fixed
                "first_name": _firstNameController.text,
                "last_name": _lastNameController.text,
                "address": _addressController.text,
                "DOB": _selectedBirthday?.toIso8601String() ?? '', // Convert to ISO date format
                "phone_number": _phoneController.text,
                "email": _emailController.text,
                "password": _passwordController.text,
                "password_confirmation": _passwordController.text,
                "profile_image": "https://i.pravatar.cc/300", // Assuming fixed image URL for now
                "bank_choice": _bankController.text,
                "incomeSources": incomeSourcesList,
              };

            try {
              // Call the register method from the AuthController
              await Provider.of<AuthController>(context, listen: false).register(registrationData);

              // Handle success (e.g., navigate to another screen or show success message)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration successful!'))
              );

              // Navigate to completion screen or next step
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => _buildCompletionStep()), 
              );
            } catch (e) {
              // Handle failure if registration fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration failed: ${e.toString()}'))
              );
            }

            }
          },
        ),

      ],
    );
  }

  Widget _buildCompletionStep() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 48, // Account for padding
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 32),
            Text(
              'Welcome to BENJI!',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Your account has been successfully created.\nLet's start managing your finances!",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, // Make button full width
              child: _buildPrimaryButton(
                text: 'Get Started',
                onPressed: () {
                  // Navigate to ProfileScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(), // Replace with the correct class name
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPrimaryButton({required String text, required VoidCallback onPressed}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
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
      backgroundColor: AppColors.background.withOpacity(0.98),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentStep == 0
                  ? _buildStepOne()
                  : _currentStep == 1
                      ? _buildStepTwo()
                      : _buildCompletionStep(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bankController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _incomeSourceController.dispose();
    _incomeAmountController.dispose();
    _incomeFrequencyController.dispose();
    _incomeDescriptionController.dispose();
    super.dispose();
  }
}