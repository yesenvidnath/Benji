import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _agreedToTerms = false;
  bool _hasMultipleIncomes = false;

  // Form Controllers
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankController = TextEditingController();
  final _singleIncomeSourceController = TextEditingController();
  final _singleIncomeAmountController = TextEditingController();
  DateTime? _selectedBirthday;
  XFile? _profileImage;
  List<Map<String, String>> incomeSources = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize with one empty income source
    incomeSources = [{'source': '', 'amount': ''}];
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  Future<void> _takePhoto() async {
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _profileImage = photo;
      });
    }
  }

  void _selectBirthday(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: AppColors.surface,
        child: CupertinoDatePicker(
          initialDateTime: DateTime(2000, 1, 1),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime dateTime) {
            setState(() {
              _selectedBirthday = dateTime;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(color: AppColors.primary, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Welcome !', style: AppTextStyles.h1),
        const SizedBox(height: 24),

        // Profile Image Section
        const Text('Take a Picture', style: AppTextStyles.h2),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.inputBackground,
            backgroundImage: _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
            child: _profileImage == null
                ? Icon(CupertinoIcons.photo, color: AppColors.primary, size: 50)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _takePhoto,
          child: Text('Take a Photo', style: AppTextStyles.linkText.copyWith(color: AppColors.accent)),
        ),
        const SizedBox(height: 20),

        // Birthday Section
        GestureDetector(
          onTap: () => _selectBirthday(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedBirthday == null ? 'Select your birthday' : '${_selectedBirthday!.toLocal()}'.split(' ')[0],
                  style: AppTextStyles.input.copyWith(
                    color: _selectedBirthday == null ? AppColors.textHint : AppColors.textPrimary
                  ),
                ),
                Icon(CupertinoIcons.calendar, color: AppColors.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Name and Email Input
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(CupertinoIcons.person, color: AppColors.primary)
          ),
          style: AppTextStyles.input,
          validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(CupertinoIcons.mail),
          ),
          style: AppTextStyles.input,
          validator: (value) => (value!.isEmpty || !value.contains('@')) ? 'Please enter a valid email' : null,
        ),
        const SizedBox(height: 16),

        // Agreement Checkbox
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _agreedToTerms,
              onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
              activeColor: AppColors.primary,
            ),
            Text('I agree to the Terms and Conditions', style: AppTextStyles.bodyMedium),
          ],
        ),
        const SizedBox(height: 16),

        _buildPrimaryButton(
          text: 'Next ›',
          onPressed: () {
            if (_formKey.currentState!.validate() && _agreedToTerms) {
              setState(() => _currentStep = 1);
            }
          },
        ),
      ],
    );
  }

  Widget _buildIncomeSourceField(Map<String, String> source, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasMultipleIncomes) ...[
            Text('Income Source ${index + 1}', style: AppTextStyles.h3),
            const SizedBox(height: 8),
          ],
          TextFormField(
            initialValue: source['source'],
            decoration: const InputDecoration(
              labelText: 'Income Source',
              prefixIcon: Icon(CupertinoIcons.briefcase),
            ),
            onChanged: (value) => setState(() => incomeSources[index]['source'] = value),
            style: AppTextStyles.input,
            validator: (value) => value!.isEmpty ? 'Enter income source' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: source['amount'],
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(CupertinoIcons.money_dollar),
            ),
            onChanged: (value) => setState(() => incomeSources[index]['amount'] = value),
            keyboardType: TextInputType.number,
            style: AppTextStyles.input,
            validator: (value) => value!.isEmpty ? 'Enter an amount' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Income Details', style: AppTextStyles.h2),
        const SizedBox(height: 20),
        
        // Multiple incomes toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Multiple incomes?', style: AppTextStyles.bodyLarge),
              Switch(
                value: _hasMultipleIncomes,
                onChanged: (value) {
                  setState(() {
                    _hasMultipleIncomes = value;
                    if (!value) {
                      // Reset to single income source
                      incomeSources = [{'source': '', 'amount': ''}];
                    }
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Income sources
        if (_hasMultipleIncomes) ...[
          ...incomeSources.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> source = entry.value;
            return _buildIncomeSourceField(source, index);
          }).toList(),
          if (incomeSources.length < 5) // Limit to 5 income sources
            _buildOutlinedButton(
              text: '+ Add Another Income Source',
              onPressed: () => setState(() => incomeSources.add({'source': '', 'amount': ''})),
            ),
        ] else
          _buildIncomeSourceField(incomeSources[0], 0),

        const SizedBox(height: 24),
        _buildPrimaryButton(
          text: 'Next ›',
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _currentStep = 2);
            }
          },
        ),
        const SizedBox(height: 16),
        _buildOutlinedButton(
          text: 'Back',
          onPressed: () => setState(() => _currentStep = 0),
        ),
      ],
    );
  }

  Widget _buildStepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Almost Done!', style: AppTextStyles.h2),
        const SizedBox(height: 20),
        
        // Phone Number
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(CupertinoIcons.phone),
          ),
          keyboardType: TextInputType.phone,
          style: AppTextStyles.input,
          validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your phone number' : null,
        ),
        const SizedBox(height: 16),
        
        // Address
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            prefixIcon: Icon(CupertinoIcons.location),
          ),
          style: AppTextStyles.input,
          validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your address' : null,
        ),
        const SizedBox(height: 16),
        
        // Bank of Choice
        TextFormField(
          controller: _bankController,
          decoration: const InputDecoration(
            labelText: 'Bank of Choice',
            prefixIcon: Icon(CupertinoIcons.building_2_fill),
          ),
          style: AppTextStyles.input,
          validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your bank of choice' : null,
        ),
        const SizedBox(height: 24),
        
        _buildPrimaryButton(
          text: 'Complete Registration',
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _currentStep = 3); // Move to completion step
            }
          },
        ),
        const SizedBox(height: 16),
        _buildOutlinedButton(
          text: 'Back',
          onPressed: () => setState(() => _currentStep = 1),
        ),
      ],
    );
  }

  Widget _buildCompletionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          CupertinoIcons.check_mark_circled_solid,
          size: 64,
          color: AppColors.primary,
        ),
        const SizedBox(height: 24),
        const Text('Registration Complete!', style: AppTextStyles.h1),
        const SizedBox(height: 16),
        Text(
          'Welcome ${_nameController.text}!',
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          'Your account has been successfully created. You can now start using the app.',
          style: AppTextStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildPrimaryButton(
          text: 'Get Started',
          onPressed: () {
            // Navigate to main app screen
            // Navigator.pushReplacement(...);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentStep == 0
                    ? _buildStepOne()
                    : _currentStep == 1
                        ? _buildStepTwo()
                        : _currentStep == 2
                            ? _buildStepThree()
                            : _buildCompletionStep(),
                            ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of all controllers
    _nameController.dispose();
    _typeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bankController.dispose();
    _singleIncomeSourceController.dispose();
    _singleIncomeAmountController.dispose();
    super.dispose();
  }
}