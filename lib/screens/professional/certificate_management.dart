import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../../widgets/common/footer_navigator.dart';

class CertificationManagementScreen extends StatelessWidget {
  const CertificationManagementScreen({Key? key}) : super(key: key);

  Widget _buildCertificationStep({
    required String title,
    required String description,
    required IconData icon,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isCompleted ? AppColors.success : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                isCompleted ? Icons.check_circle : Icons.chevron_right,
                color: isCompleted ? AppColors.success : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Certification Progress',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'certification',
              userName: 'Certification',
              onMenuPressed: () => Navigator.pop(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressIndicator(0.4), // 40% progress
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCertificationStep(
                            title: 'Personal Information',
                            description: 'Complete your professional profile',
                            icon: Icons.person,
                            isCompleted: true,
                            onTap: () {
                              // Handle navigation to personal info section
                            },
                          ),
                          _buildCertificationStep(
                            title: 'Upload Documents',
                            description: 'Submit required certifications and licenses',
                            icon: Icons.upload_file,
                            isCompleted: true,
                            onTap: () {
                              // Handle navigation to document upload section
                            },
                          ),
                          _buildCertificationStep(
                            title: 'Professional Experience',
                            description: 'Add your work history and expertise',
                            icon: Icons.work,
                            isCompleted: false,
                            onTap: () {
                              // Handle navigation to experience section
                            },
                          ),
                          _buildCertificationStep(
                            title: 'Skills Assessment',
                            description: 'Complete the professional skills evaluation',
                            icon: Icons.psychology,
                            isCompleted: false,
                            onTap: () {
                              // Handle navigation to assessment section
                            },
                          ),
                          _buildCertificationStep(
                            title: 'Background Check',
                            description: 'Verify your professional background',
                            icon: Icons.verified_user,
                            isCompleted: false,
                            onTap: () {
                              // Handle navigation to background check section
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submission
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Submit for Review'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavigator(currentRoute: 'certification'),
    );
  }
}