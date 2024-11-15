import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/professional.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';
import './payments_screen.dart';

class BookingScreen extends StatefulWidget {
  final Professional professional;
  
  const BookingScreen({
    super.key,
    required this.professional,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController descriptionController = TextEditingController();

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget _buildCustomInputField({
    required String label,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime.now().add(const Duration(days: 365)),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      selectedDate = newDateTime;
                      selectedTime = TimeOfDay.fromDateTime(newDateTime);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime() {
    return '${selectedDate.day} ${_getMonth(selectedDate.month)} ${selectedDate.year} '
           '${selectedTime.format(context)}';
  }

  String _getMonth(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildProfessionalCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              // ignore: unnecessary_null_comparison
              image: widget.professional.avatarUrl != null
                  ? DecorationImage(
                      image: AssetImage(widget.professional.avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            // ignore: unnecessary_null_comparison
            child: widget.professional.avatarUrl == null
                ? Icon(
                    CupertinoIcons.person_fill,
                    size: 60,
                    color: AppColors.primary.withOpacity(0.7),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            widget.professional.name,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.professional.role,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.star_fill,
                size: 18,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.professional.rating}',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(width: 8),
              Text(
                '(${widget.professional.reviewCount} reviews)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.professional.isAvailable
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.professional.isAvailable ? 'Available' : 'Unavailable',
              style: AppTextStyles.bodySmall.copyWith(
                color: widget.professional.isAvailable
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'booking',
              userName: 'Book Professional',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfessionalCard(),
                    const SizedBox(height: 16),
                    
                    // Date and Time Picker
                    _buildCustomInputField(
                      label: 'Date and Time',
                      child: InkWell(
                        onTap: _showDateTimePicker,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.calendar,
                                color: AppColors.primary.withOpacity(0.7),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _formatDateTime(),
                                style: AppTextStyles.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Description Field
                    _buildCustomInputField(
                      label: 'Description',
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        style: AppTextStyles.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Enter booking description...',
                          hintStyle: AppTextStyles.inputHint,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          prefixIcon: Icon(
                            CupertinoIcons.doc_text,
                            color: AppColors.primary.withOpacity(0.7),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Booking Button
            Padding(
              padding: const EdgeInsets.all(16),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            professional: widget.professional,
                            bookingDateTime: _formatDateTime(),
                            description: descriptionController.text,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Book Appointment',
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
            const FooterNavigator(currentRoute: 'booking'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}