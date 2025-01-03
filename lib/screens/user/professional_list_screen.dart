import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/professional.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../controllers/meetings_controller.dart';
import './booking_screen.dart';

class ProfessionalListScreen extends StatefulWidget {
  const ProfessionalListScreen({super.key});

  @override
  State<ProfessionalListScreen> createState() => _ProfessionalListScreenState();
}

class _ProfessionalListScreenState extends State<ProfessionalListScreen> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedFilter = 'All Professionals';

  final List<Professional> professionals = [
    
  ];

  String searchQuery = '';

  List<Professional> get filteredProfessionals {
    final meetingsController = Provider.of<MeetingsController>(context, listen: true);

    if (meetingsController.allProfessionals.isEmpty) {
      return [];
    }

    List<Professional> professionals = meetingsController.allProfessionals.map((data) {
      return Professional(
        id: data['user_ID']?.toString() ?? 'Unknown',
        name: data['full_name'] ?? 'Unknown',
        role: data['type'] ?? 'Unknown',
        avatarUrl: data['profile_image'] ?? '',
        rating: 4.5,
        reviewCount: 100,
        specialization: data['type'] ?? 'Unknown',
        isAvailable: data['status'] == 'active',
        chargePerHr: (data['charge_per_Hr'] as num?)?.toDouble() ?? 0.0, // Map hourly charge
      );
    }).toList();

    return professionals.where((professional) {
      final matchesFilter = selectedFilter == 'All Professionals' || 
                            professional.role == selectedFilter;
      final matchesSearch = professional.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            professional.role.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            professional.specialization.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }


  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigateToBooking(BuildContext context, Professional professional) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(professional: professional),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final meetingsController = Provider.of<MeetingsController>(context, listen: false);
    try {
      await meetingsController.fetchAllProfessionals();
      await meetingsController.fetchAllProfessionalTypes();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
     final meetingsController = Provider.of<MeetingsController>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background.withOpacity(0.98),
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'professionals',
              userName: 'Find Your Expert',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.search,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
                                  style: const TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: 'Search professionals...',
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(
                                label: 'All Professionals',
                                isSelected: selectedFilter == 'All Professionals',
                                onSelected: (value) => setState(() => selectedFilter = 'All Professionals'),
                              ),
                              ...meetingsController.allProfessionalTypes.map((type) {
                                return _FilterChip(
                                  label: type,
                                  isSelected: selectedFilter == type,
                                  onSelected: (value) => setState(() => selectedFilter = type),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: meetingsController.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredProfessionals.length,
                            itemBuilder: (context, index) {
                              final professional = filteredProfessionals[index];
                              return GestureDetector(
                                onTap: () => _navigateToBooking(context, professional),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: AppColors.primaryLight,
                                              ),
                                              child: professional.avatarUrl.isNotEmpty
                                                  ? Image.network(professional.avatarUrl)
                                                  : const Icon(
                                                      Icons.person,
                                                      size: 40,
                                                      color: AppColors.primary,
                                                    ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    professional.name,
                                                    style: AppTextStyles.bodySmall,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    professional.role,
                                                    style: AppTextStyles.bodyMedium.copyWith(
                                                      color: AppColors.textSecondary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        size: 16,
                                                        color: Colors.amber,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${professional.rating}',
                                                        style: AppTextStyles.bodyMedium,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        '(${professional.reviewCount} reviews)',
                                                        style: AppTextStyles.bodySmall.copyWith(
                                                          color: AppColors.textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryLight,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  professional.specialization,
                                                  style: AppTextStyles.bodySmall.copyWith(
                                                    color: AppColors.background,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: professional.isAvailable
                                                    ? AppColors.success.withOpacity(0.1)
                                                    : AppColors.error.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    size: 8,
                                                    color: professional.isAvailable
                                                        ? AppColors.success
                                                        : AppColors.error,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    professional.isAvailable
                                                        ? 'Available'
                                                        : 'Unavailable',
                                                    style: AppTextStyles.bodySmall.copyWith(
                                                      color: professional.isAvailable
                                                          ? AppColors.success
                                                          : AppColors.error,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),


                ],
              ),
            ),
            const FooterNavigator(currentRoute: 'professionals'),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
        ),
      ),
    );
  }
}