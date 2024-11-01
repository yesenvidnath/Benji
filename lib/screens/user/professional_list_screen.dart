import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/professional.dart';
import '../../../widgets/common/footer_navigator.dart';
import './booking_screen.dart';

class ProfessionalListScreen extends StatelessWidget {
  ProfessionalListScreen({Key? key}) : super(key: key);

  final List<Professional> professionals = [
    Professional(
      name: 'Jouye Medison',
      role: 'Accountant',
      avatarUrl: 'assets/avatars/jouye.png',
    ),
    Professional(
      name: 'Lucas Abraham',
      role: 'Banker',
      avatarUrl: 'assets/avatars/lucas.png',
    ),
    Professional(
      name: 'John Kealn',
      role: 'Stock Broker',
      avatarUrl: 'assets/avatars/john.png',
    ),
    Professional(
      name: 'Yossy Angela',
      role: 'Financial Advisor',
      avatarUrl: 'assets/avatars/yossy.png',
    ),
    Professional(
      name: 'Julia Agustine',
      role: 'Accountant',
      avatarUrl: 'assets/avatars/julia.png',
    ),
  ];

  void _navigateToBooking(BuildContext context, Professional professional) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(professional: professional),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Professionals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Filter',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Now',
                          style: AppTextStyles.bodyMedium,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                final professional = professionals[index];
                return GestureDetector(
                  onTap: () => _navigateToBooking(context, professional),
                  child: Card(
                    color: AppColors.surface,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primaryLight,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  professional.name,
                                  style: AppTextStyles.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  professional.role,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Available',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const FooterNavigator(currentRoute: 'profile'),
        ],
        
      ),
      
    );
  }
}