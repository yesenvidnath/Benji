import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening URLs
import 'package:share_plus/share_plus.dart'; // For sharing URLs
import '../../../core/theme/text_styles.dart';
import 'package:flutter/services.dart';
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
  final String paymentUrl;
  final int meetingId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  
  PaymentStatusScreen({
    super.key,
    this.status = PaymentStatus.success,
    required this.professionalName,
    required this.professionalRole,
    required this.amount,
    required this.adminFee,
    required this.paymentUrl,
    required this.meetingId,
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
                          ? 'Meeting Booked Successfuly!' 
                          : 'Meeting Failed',
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

                    // Meeting ID
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Payment URL',
                                style: AppTextStyles.bodyMedium,
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: paymentUrl));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Payment URL copied to clipboard'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(CupertinoIcons.doc_on_doc, size: 18, color: Colors.blue),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            paymentUrl,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
                          // Complete Payment Button
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
                                  onTap: () async {
                                    if (paymentUrl.isNotEmpty) {
                                      print("Attempting to launch URL: $paymentUrl");
                                      final Uri url = Uri.parse(paymentUrl);
                                      try {
                                        final canLaunch = await canLaunchUrl(url);
                                        print("Can launch URL: $canLaunch");
                                        
                                        if (canLaunch) {
                                          final result = await launchUrl(
                                            url,
                                            mode: LaunchMode.inAppWebView,
                                            webViewConfiguration: const WebViewConfiguration(
                                              enableJavaScript: true,
                                              enableDomStorage: true,
                                            ),
                                          );
                                          print("Launch result: $result");
                                        } else {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Unable to launch payment URL")),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                       
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Benji is having difuculty redirecting, please  copy and pate the code to your browser")),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Complete Payment',
                                      style: AppTextStyles.button.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Share Button
                          IconButton(
                            onPressed: () {
                              Share.share('Payment Link: $paymentUrl');
                            },
                            icon: const Icon(CupertinoIcons.share, color: Color(0xFF0A0F44)),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary.withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
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