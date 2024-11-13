import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../../widgets/common/header_navigator.dart';


class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({super.key});

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  late TabController _incomeTabController;
  DateTime? _selectedBirthday;
  
  // Profile Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Income Source Controllers
  final _incomeSourceController = TextEditingController();
  final _incomeAmountController = TextEditingController();
  final _incomeFrequencyController = TextEditingController();
  final _incomeDescriptionController = TextEditingController();
  
  final _editIncomeFormKey = GlobalKey<FormState>();
  
 // bool _hasMultipleIncomes = false;
  
  List<Map<String, dynamic>> incomeSources = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _incomeTabController = TabController(length: 2, vsync: this);
  }

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _showFrequencyPicker() {
    final frequencies = ['Daily', 'Weekly', 'Bi-weekly', 'Monthly', 'Quarterly', 'Yearly'];
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 200,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32,
            onSelectedItemChanged: (int selectedItem) {
              setState(() {
                _incomeFrequencyController.text = frequencies[selectedItem];
              });
            },
            children: frequencies.map((String frequency) {
              return Center(
                child: Text(
                  frequency,
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _addIncomeSource() {
    if (_incomeSourceController.text.isEmpty ||
        _incomeAmountController.text.isEmpty ||
        _incomeFrequencyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      incomeSources.add({
        'source': _incomeSourceController.text,
        'amount': _incomeAmountController.text,
        'frequency': _incomeFrequencyController.text,
        'description': _incomeDescriptionController.text,
      });

      // Clear the form
      _incomeSourceController.clear();
      _incomeAmountController.clear();
      _incomeFrequencyController.clear();
      _incomeDescriptionController.clear();
    });
  }

    void _editIncomeSource(Map<String, dynamic> income) {
    // Set the form values
    _incomeSourceController.text = income['source'];
    _incomeAmountController.text = income['amount'];
    _incomeFrequencyController.text = income['frequency'];
    _incomeDescriptionController.text = income['description'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => CustomBottomSheet(
        title: 'Edit Income Source',
        content: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _editIncomeFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInputField(
                  label: 'Income Source',
                  hint: 'e.g., Salary, Business',
                  icon: CupertinoIcons.doc_text,
                  controller: _incomeSourceController,
                ),
                _buildInputField(
                  label: 'Amount',
                  hint: '0.00',
                  icon: CupertinoIcons.money_dollar,
                  controller: _incomeAmountController,
                  keyboardType: TextInputType.number,
                ),
                _buildInputField(
                  label: 'Frequency',
                  hint: 'Select frequency',
                  icon: CupertinoIcons.calendar,
                  controller: _incomeFrequencyController,
                  readOnly: true,
                  onTap: _showFrequencyPicker,
                ),
                _buildInputField(
                  label: 'Description',
                  hint: 'Add a description',
                  icon: CupertinoIcons.text_justify,
                  controller: _incomeDescriptionController,
                ),
                const SizedBox(height: 24),
                _buildPrimaryButton(
                  text: 'Save Changes',
                  onPressed: () {
                    if (_editIncomeFormKey.currentState?.validate() ?? false) {
                      setState(() {
                        final index = incomeSources.indexWhere(
                          (source) => source['source'] == income['source'],
                        );
                        if (index != -1) {
                          incomeSources[index] = {
                            'source': _incomeSourceController.text,
                            'amount': _incomeAmountController.text,
                            'frequency': _incomeFrequencyController.text,
                            'description': _incomeDescriptionController.text,
                          };
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: incomeSources.length,
      itemBuilder: (context, index) {
        final income = incomeSources[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
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
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '\$',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                income['source'],
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                '${income['frequency']}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${income['amount']}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.pencil,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () => _editIncomeSource(income),
                  ),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.trash,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        incomeSources.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
              onTap: () => _editIncomeSource(income),
            ),
          ),
        );
      },
    );
  }


  Widget _buildIncomeCard(Map<String, dynamic> income) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  income['source'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${income['amount']} ${income['frequency']}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (income['description'].isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    income['description'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.delete, color: AppColors.error),
            onPressed: () {
              setState(() {
                incomeSources.remove(income);
              });
            },
          ),
        ],
      ),
    );
  }

  
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            style: AppTextStyles.input.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.inputHint,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              prefixIcon: Icon(
                icon,
                color: AppColors.primary.withOpacity(0.7),
                size: 22,
              ),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Change Profile Picture',
          style: AppTextStyles.bodyMedium,
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Add camera image picking logic here
            },
            child: const Text( 
              'Take Photo',
               style: TextStyle(color: AppColors.primary),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Add gallery image picking logic here
            },
            child: const Text(
              'Choose from Gallery',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(
            CupertinoIcons.person_fill,
            size: 50,
            color: AppColors.primary,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.camera_fill,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBirthdayPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedBirthday ?? DateTime.now().subtract(const Duration(days: 6570)),
            maximumDate: DateTime.now().subtract(const Duration(days: 4380)),
            minimumDate: DateTime.now().subtract(const Duration(days: 36500)),
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedBirthday = newDateTime;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback onPressed}) {
    return Container(
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
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.button.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildProfileImage(),
        const SizedBox(height: 32),
        _buildInputField(
          label: 'Full Name',
          hint: 'John Doe',
          icon: CupertinoIcons.person,
          controller: _nameController,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        _buildInputField(
          label: 'Birthday',
          hint: _selectedBirthday != null 
            ? '${_selectedBirthday!.month}/${_selectedBirthday!.day}/${_selectedBirthday!.year}'
            : 'Select your birthday',
          icon: CupertinoIcons.calendar,
          controller: TextEditingController(
            text: _selectedBirthday != null 
              ? '${_selectedBirthday!.month}/${_selectedBirthday!.day}/${_selectedBirthday!.year}'
              : '',
          ),
          readOnly: true,
          onTap: _showBirthdayPicker,
        ),
        _buildInputField(
          label: 'Phone Number',
          hint: '+1 234 567 8900',
          icon: CupertinoIcons.phone,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
        ),
        _buildInputField(
          label: 'Email Address',
          hint: 'example@gmail.com',
          icon: CupertinoIcons.mail,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
        ),
        const SizedBox(height: 32),
        _buildPrimaryButton(
          text: 'Save Changes',
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Profile updated successfully',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildIncomeSourcesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: TabBar(
              controller: _incomeTabController,
              labelStyle: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
                fontSize: 15,
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary.withOpacity(0.1),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              tabs: const [
                Tab(text: 'Add New'),
                Tab(text: 'Edit'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _incomeTabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildInputField(
                      label: 'Income Source',
                      hint: 'e.g., Salary, Business',
                      icon: CupertinoIcons.doc_text,
                      controller: _incomeSourceController,
                    ),
                    _buildInputField(
                      label: 'Amount',
                      hint: '0.00',
                      icon: CupertinoIcons.money_dollar,
                      controller: _incomeAmountController,
                      keyboardType: TextInputType.number,
                    ),
                    _buildInputField(
                      label: 'Frequency',
                      hint: 'Select frequency',
                      icon: CupertinoIcons.calendar,
                      controller: _incomeFrequencyController,
                      readOnly: true,
                      onTap: _showFrequencyPicker,
                    ),
                    _buildInputField(
                      label: 'Description',
                      hint: 'Add a description',
                      icon: CupertinoIcons.text_justify,
                      controller: _incomeDescriptionController,
                    ),
                    const SizedBox(height: 24),
                    _buildPrimaryButton(
                      text: 'Add Income Source',
                      onPressed: _addIncomeSource,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildIncomeList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'profile',
              userName: 'Profile',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelStyle: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 15,
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(text: 'Profile Info'),
                    Tab(text: 'Income Sources'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: _buildProfileForm(),
                    ),
                  ),
                  _buildIncomeSourcesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavigator(currentRoute: 'profile'),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _incomeTabController.dispose();
    _incomeSourceController.dispose();
    _incomeAmountController.dispose();
    _incomeFrequencyController.dispose();
    _incomeDescriptionController.dispose();
    super.dispose();
  }
}

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;

  const CustomBottomSheet({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          content,
        ],
      ),
    );
  }
}