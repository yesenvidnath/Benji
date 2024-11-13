import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  PaymentStatusScreen({
    super.key,
    this.status = PaymentStatus.success,
    required this.professionalName,
    required this.professionalRole,
    required this.amount,
    required this.adminFee,
  });

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final double total = amount + adminFee;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background.withOpacity(0.98),
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'payment',
              userName: 'Payment Status',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Status Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status == PaymentStatus.success 
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                      ),
                      child: Icon(
                        status == PaymentStatus.success 
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons.xmark_circle_fill,
                        size: 40,
                        color: status == PaymentStatus.success 
                            ? AppColors.success 
                            : AppColors.error,
                      ),
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
                    
                    // Professional Info Card
                    Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              professionalName[0],
                              style: AppTextStyles.h1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            professionalName,
                            style: AppTextStyles.h3,
                          ),
                          Text(
                            professionalRole,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildPaymentDetailRow(
                            'Service Fee',
                            'Rs.${amount.toStringAsFixed(2)}',
                            CupertinoIcons.money_dollar,
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentDetailRow(
                            'Admin Fee',
                            'Rs.${adminFee.toStringAsFixed(2)}',
                            CupertinoIcons.doc_text,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(),
                          ),
                          _buildPaymentDetailRow(
                            'Total Amount',
                            'Rs.${total.toStringAsFixed(2)}',
                            CupertinoIcons.cart,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    // Transaction ID
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transaction ID',
                            style: AppTextStyles.bodyMedium,
                          ),
                          Row(
                            children: [
                              Text(
                                '#TRX${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(CupertinoIcons.doc_on_doc, size: 18, color: Colors.blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
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
                                  onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                                  child: Center(
                                    child: Text(
                                      'Back to Home',
                                      style: AppTextStyles.button.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.share, color: Color(0xFF0A0F44)),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary.withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const FooterNavigator(currentRoute: 'profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String amount, IconData icon, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isTotal ? AppColors.primaryButton : AppColors.primaryButton,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isTotal ? Colors.black87 : Colors.black54,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        Text(
          amount,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.primaryButton : AppColors.primaryButton,
          ),
        ),
      ],
    );
  }
}