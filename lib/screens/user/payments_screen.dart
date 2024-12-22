import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/professional.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../controllers/meetings_controller.dart';
import './payment_status_screen.dart';
import 'package:intl/intl.dart';


class PaymentScreen extends StatefulWidget {
  final Professional professional;
  final String bookingDateTime;

  const PaymentScreen({
    super.key,
    required this.professional,
    required this.bookingDateTime,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isProcessing = false;
  

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _proceedToPayment() async {
    final meetingsController = Provider.of<MeetingsController>(context, listen: false);

    setState(() {
      isProcessing = true; // Ensure `isProcessing` is in your state
    });

    try {
      // Parse the current bookingDateTime format
      final parsedDateTime = DateFormat('dd MMMM yyyy h:mm a').parse(widget.bookingDateTime);

      // Reformat to 'yyyy-MM-dd HH:mm:ss' for the API
      final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDateTime);

      // Call the API with the formatted datetime
      await meetingsController.bookMeeting(
        int.parse(widget.professional.id), // Convert id to int
        formattedDateTime, // Pass formatted datetime
      );

      final response = meetingsController.bookingResponse;
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );

        // Navigate to PaymentStatusScreen with payment details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentStatusScreen(
              status: PaymentStatus.success,
              professionalName: widget.professional.name,
              professionalRole: widget.professional.role,
              amount: widget.professional.chargePerHr,
              adminFee: 150.50, // Platform fee
              meetingId: response['meeting_id'], // Pass meeting ID
              paymentUrl: response['payment_url'], // Pass payment URL
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to book meeting: $e")),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    // Calculate charges
    final double consultationFee = widget.professional.chargePerHr;
    const double adminFee = 150.50;
    final double totalAmount = consultationFee + adminFee;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background.withOpacity(0.98),
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'payment',
              userName: 'Payment Details',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Professional Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
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
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: widget.professional.avatarUrl.isNotEmpty
                                          ? NetworkImage(widget.professional.avatarUrl)
                                          : null,
                                      backgroundColor: AppColors.primaryLight,
                                      child: widget.professional.avatarUrl.isEmpty
                                          ? const Icon(Icons.person, size: 35, color: AppColors.textPrimary)
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.professional.name,
                                            style: AppTextStyles.bodyLarge.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.professional.role,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.star, size: 16, color: Colors.amber[700]),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${widget.professional.rating} (${widget.professional.reviewCount} reviews)',
                                                style: AppTextStyles.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Appointment Details
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Appointment Details',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
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
                                  children: [
                                    _buildDetailRow(
                                      CupertinoIcons.calendar,
                                      'Date & Time',
                                      widget.bookingDateTime,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Divider(),
                                    ),
                                    _buildDetailRow(
                                      CupertinoIcons.doc_text,
                                      'Service',
                                      widget.professional.specialization,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Payment Summary
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Payment Summary',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
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
                                  children: [
                                    _buildPaymentRow('Consultation Fee', 'Rs.${consultationFee.toStringAsFixed(2)}'),
                                    const SizedBox(height: 12),
                                    _buildPaymentRow('Platform Fee', 'Rs.${adminFee.toStringAsFixed(2)}'),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Divider(),
                                    ),
                                    _buildPaymentRow(
                                      'Total Amount',
                                      'Rs.${totalAmount.toStringAsFixed(2)}',
                                      isTotal: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Payment Button
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
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
                          onTap: isProcessing ? null : _proceedToPayment,
                          child: Center(
                            child: isProcessing
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Proceed to Payment',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const FooterNavigator(currentRoute: 'payment'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
