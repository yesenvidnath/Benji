import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/professional.dart';
import '../../../widgets/common/footer_navigator.dart';
import './payments_screen.dart';

class BookingScreen extends StatefulWidget {
  final Professional professional;
  
  const BookingScreen({
    Key? key,
    required this.professional,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.primary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.primary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Booking', style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
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
                  // Professional Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Professional Name
                  Text(
                    widget.professional.name,
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Professional Role
                  Text(
                    widget.professional.role,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Date and Time Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.inputBorder,
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await _selectDate(context);
                          await _selectTime(context);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: AppColors.accent,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Date Time - ${_formatDateTime()}',
                                style: AppTextStyles.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Description Section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: descriptionController,
                          maxLines: 4,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'Enter booking description...',
                            hintStyle: AppTextStyles.inputHint,
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.inputBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.inputBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Book a Meet Now Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.buttonText,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Book a Meet Now',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ),

          const FooterNavigator(currentRoute: 'profile'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}