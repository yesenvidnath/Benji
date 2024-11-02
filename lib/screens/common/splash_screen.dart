import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: LogoPainter(),
                ),
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
    );
  }
}

// Custom painter for the logo
class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final double unit = size.width / 6;
    
    // Outer square
    Path outerPath = Path()
      ..moveTo(unit, unit)
      ..lineTo(5 * unit, unit)
      ..lineTo(5 * unit, 5 * unit)
      ..lineTo(unit, 5 * unit)
      ..lineTo(unit, unit);
    
    // Inner square
    Path innerPath = Path()
      ..moveTo(2 * unit, 2 * unit)
      ..lineTo(4 * unit, 2 * unit)
      ..lineTo(4 * unit, 4 * unit)
      ..lineTo(2 * unit, 4 * unit)
      ..lineTo(2 * unit, 2 * unit);

    // Draw the connecting lines
    Path connectingPath = Path()
      ..moveTo(2 * unit, 2 * unit)
      ..lineTo(unit, unit)
      ..moveTo(4 * unit, 2 * unit)
      ..lineTo(5 * unit, unit)
      ..moveTo(4 * unit, 4 * unit)
      ..lineTo(5 * unit, 5 * unit)
      ..moveTo(2 * unit, 4 * unit)
      ..lineTo(unit, 5 * unit);

    canvas.drawPath(outerPath, paint);
    canvas.drawPath(innerPath, paint);
    canvas.drawPath(connectingPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}