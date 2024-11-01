import 'package:benji/screens/common/login_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _agreedToTerms = false;

  // Form Controllers
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankController = TextEditingController();

  // Income Sources List
  List<Map<String, String>> incomeSources = [];

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome !', style: AppTextStyles.h1),
        const SizedBox(height: 32),
        TextFormField(
          controller: _nameController,
          style: AppTextStyles.input,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _typeController,
          style: AppTextStyles.input,
          decoration: const InputDecoration(
            labelText: 'Type',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          style: AppTextStyles.input,
          decoration: const InputDecoration(
            labelText: 'Email Address',
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your email';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          style: AppTextStyles.input,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            suffixIcon: Icon(Icons.visibility_off),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter a password' : null,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Checkbox(
              value: _agreedToTerms,
              onChanged: (value) {
                setState(() {
                  _agreedToTerms = value ?? false;
                });
              },
            ),
            const Text(
              'I have agree to our ',
              style: AppTextStyles.bodyMedium,
            ),
            const Text(
              'Terms and Condition',
              style: AppTextStyles.link,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() {
                _currentStep = 1;
              });
            }
          },
          child: const Text('sign up ›'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            // Handle login navigation
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('login'),
        ),
        const SizedBox(height: 16),
        Center(
          child: RichText(
            text: const TextSpan(
              style: AppTextStyles.bodyMedium,
              children: [
                TextSpan(text: 'Already have an account? '),
                TextSpan(
                  text: 'Sign In',
                  style: AppTextStyles.link,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...incomeSources.map((source) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: source['source'],
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      labelText: 'Income Source',
                    ),
                    onChanged: (value) {
                      source['source'] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: source['amount'],
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                    ),
                    onChanged: (value) {
                      source['amount'] = value;
                    },
                  ),
                ],
              ),
            )).toList(),
        OutlinedButton(
          onPressed: () {
            setState(() {
              incomeSources.add({'source': '', 'amount': ''});
            });
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            side: const BorderSide(color: AppColors.primary, style: BorderStyle.solid),
          ),
          child: const Text('+ Add Another'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = 2;
            });
          },
          child: const Text('Complete'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _currentStep = 0;
            });
          },
          child: const Text('Back'),
        ),
      ],
    );
  }

  Widget _buildStepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _phoneController,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/flag.png', width: 24, height: 16),
                  const SizedBox(width: 8),
                  const Text('+62', style: AppTextStyles.input),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _birthdayController,
          style: AppTextStyles.input,
          decoration: const InputDecoration(
            labelText: 'Birthday',
            prefixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          style: AppTextStyles.input,
          decoration: const InputDecoration(
            labelText: 'Address',
            prefixIcon: Icon(Icons.location_on),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bankController,
          style: AppTextStyles.input,
          decoration: const InputDecoration(
            labelText: 'Bank of Choice',
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // Handle registration completion
          },
          child: const Text('Save'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _currentStep = 1;
            });
          },
          child: const Text('Back'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      : _buildStepThree(),
            ),
          ),
        ),
      ),
    );
  }
}