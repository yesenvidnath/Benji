// lib/screens/user/payments_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/professional.dart';
import '../../../widgets/common/footer_navigator.dart';
import './payment_status_screen.dart';

class PaymentScreen extends StatelessWidget {
  final Professional professional;
  final String bookingDateTime;
  final String description;
  
  const PaymentScreen({
    super.key,
    required this.professional,
    required this.bookingDateTime,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    const double amount = 1500.00;
    const double adminFee = 150.50;
    const double total = amount + adminFee;

    return Scaffold(
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
                  // Payment Title Circle
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(Icons.person, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          professional.name,
                          style: AppTextStyles.bodyLarge,
                        ),
                        Text(
                          professional.role,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
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
          
          // Pay Now Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                    // Handle payment processing
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentStatusScreen(
                          status: PaymentStatus.success, // or PaymentStatus.failure based on payment result
                          professionalName: professional.name,
                          professionalRole: professional.role,
                          amount: amount,
                          adminFee: adminFee,
                        ),
                      ),
                    );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A0F44),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
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

