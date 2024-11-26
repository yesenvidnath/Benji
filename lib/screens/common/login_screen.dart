import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import 'profile_screen.dart';
import 'register_screen.dart';

//importing the auth controller 
import '../../controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.withOpacity(0.98),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Container(
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
                ),
                const SizedBox(height: 32),

                // Title and Tagline
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
                      'Budget Smarter, Not Harder!',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Input Fields
                _buildInputField(
                  label: 'Email Address',
                  hint: 'example@gmail.com',
                  controller: _emailController,
                  isPassword: false,
                  icon: CupertinoIcons.mail,
                ),
                const SizedBox(height: 24),

                _buildInputField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  isPassword: true,
                  icon: CupertinoIcons.lock,
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Login Button
                Container(
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
                      onTap: () async{
                        // Show loading overlay
                        showDialog(
                          context: context, 
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        try{
                          // Calling the login function 
                          await Provider.of<AuthController>(context, listen: false).login(
                            _emailController.text,
                            _passwordController.text,
                          );

                          //Close loading overlay
                          Navigator.of(context).pop();

                          //Check if login was successful by accesingthe isLoggin State
                          if (Provider.of <AuthController>(context, listen: false).isLoggedIn){
                            //display snackbar 
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login was Successful!")),
                            );

                            //Redirect to profile 
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (context) => ProfileScreen()),
                            );
                          } else{
                            // Show error SnackBar if login fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login failed. Please check your credentials.")),
                            );
                          }
                        }catch(e){
                          // Close loading overlay in case of error
                          Navigator.of(context).pop();

                          // Show error SnackBar if an exception is thrown
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("An error occurred: $e")),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          'Log In',
                          style: AppTextStyles.button.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sign Up Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.link.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isPassword,
    required IconData icon,
  }) {
    return Container(
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
          TextField(
            controller: controller,
            obscureText: isPassword && !_passwordVisible,
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
          ),
        ],
      ),
    );
  }
}