import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward(); // Starts the animation

    // Optionally, add a delay or navigate after the animation finishes
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the next screen or perform another action here if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _animationController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value * 1.2,
                      child: Lottie.asset(
                        'animations/logo.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // App Name
                Text(
                  'BENJI',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Budget Smarter, Not Harder!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
