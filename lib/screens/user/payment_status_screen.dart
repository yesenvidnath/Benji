// lib/screens/user/payment_status_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';

enum PaymentStatus {
  success,
  failure
}

class PaymentStatusScreen extends StatelessWidget {
  final PaymentStatus status;
  final String professionalName;
  final String professionalRole;
  final double amount;
  final double adminFee;
  
  const PaymentStatusScreen({
    super.key,
    this.status = PaymentStatus.success,
    required this.professionalName,
    required this.professionalRole,
    required this.amount,
    required this.adminFee,
  });

  @override
  Widget build(BuildContext context) {
    final double total = amount + adminFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Status Circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0A0F44),
                    ),
                    child: const Center(
                      child: Text(
                        'Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Professional Info Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            professionalName[0],
                            style: AppTextStyles.h2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          professionalName,
                          style: AppTextStyles.bodyLarge,
                        ),
                        Text(
                          professionalRole,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  
                  // Payment Details
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildPaymentRow('Amount', 'Rs.${amount.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        _buildPaymentRow('Admin fee', 'Rs.${adminFee.toStringAsFixed(2)}'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: AppColors.inputBorder),
                        ),
                        _buildPaymentRow('Total', 'Rs.${total.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),

                  // Status Message
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Icon(
                          status == PaymentStatus.success 
                              ? Icons.check_circle 
                              : Icons.error,
                          size: 64,
                          color: status == PaymentStatus.success 
                              ? AppColors.success 
                              : AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          status == PaymentStatus.success 
                              ? 'Payment Successful!' 
                              : 'Payment Failed',
                          style: AppTextStyles.h2.copyWith(
                            color: status == PaymentStatus.success 
                                ? AppColors.success 
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          status == PaymentStatus.success 
                              ? 'Your payment has been processed successfully'
                              : 'There was an error processing your payment',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Barcode
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 80,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/barcode.png'),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to home or show receipt
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A0F44),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  status == PaymentStatus.success ? 'Back to Home' : 'Try Again',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          const FooterNavigator(currentRoute: 'profile'),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          amount,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}