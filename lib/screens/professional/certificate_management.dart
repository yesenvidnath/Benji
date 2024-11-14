import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../../widgets/common/footer_navigator.dart';

class CertificationUploadScreen extends StatefulWidget {
  const CertificationUploadScreen({Key? key}) : super(key: key);

  @override
  _CertificationUploadScreenState createState() => _CertificationUploadScreenState();
}

class _CertificationUploadScreenState extends State<CertificationUploadScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _certificationNameController = TextEditingController();
  late DateTime _expiryDate;
  Map<String, bool> _uploadedFiles = {
    'certificate': false,
    'nicFront': false,
    'nicBack': false,
    'photo': false,
  };

  @override
  void initState() {
    super.initState();
    _expiryDate = DateTime.now();
  }

  void _handleMenuPress(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget _buildInputField({
    required Widget child,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(
              icon,
              color: AppColors.primary.withOpacity(0.7),
              size: 22,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Future<void> _showExpiryDatePicker() async {
    DateTime? tempDate = _expiryDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('Cancel', style: TextStyle(color: AppColors.primary)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text('Done', style: TextStyle(color: AppColors.primary)),
                    onPressed: () {
                      setState(() => _expiryDate = tempDate!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _expiryDate,
                  minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showImageSourceDialog(String type) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Image Source',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        // Implement camera capture
                        setState(() => _uploadedFiles[type] = true);
                        Navigator.pop(context);
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        // Implement gallery picker
                        setState(() => _uploadedFiles[type] = true);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required String label,
    required String type,
    bool allowMultiple = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        onTap: () => _showImageSourceDialog(type),
        leading: Icon(
          _uploadedFiles[type] == true ? Icons.check_circle : Icons.upload_file,
          color: _uploadedFiles[type] == true ? AppColors.success : AppColors.primary,
        ),
        title: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: _uploadedFiles[type] == true ? AppColors.success : AppColors.primary,
          ),
        ),
        subtitle: allowMultiple
            ? Text(
                'You can upload multiple images',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              )
            : null,
        trailing: Icon(CupertinoIcons.chevron_right, color: AppColors.primary.withOpacity(0.5)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Congratulations!',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The admin will confirm your professional account.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background.withOpacity(0.98),
      drawer: HeaderNavigator.buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            HeaderNavigator(
              currentRoute: 'certification',
              userName: 'Upload Certification',
              onMenuPressed: () => _handleMenuPress(context),
              onSearchPressed: () {},
              onProfilePressed: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputField(
                        icon: CupertinoIcons.doc_text,
                        child: TextFormField(
                          controller: _certificationNameController,
                          style: AppTextStyles.input,
                          decoration: InputDecoration(
                            labelText: 'Certification Name',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            labelStyle: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),

                      InkWell(
                        onTap: _showExpiryDatePicker,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                            children: [
                              Icon(CupertinoIcons.calendar,
                                  color: AppColors.primary.withOpacity(0.7)),
                              const SizedBox(width: 12),
                              Text(
                                'Certification issued date ${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              Icon(CupertinoIcons.chevron_right,
                                  color: AppColors.primary.withOpacity(0.5)),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      
                      _buildUploadButton(
                        label: 'Upload Certificate Images',
                        type: 'certificate',
                        allowMultiple: true,
                      ),
                      _buildUploadButton(
                        label: 'Upload NIC Front',
                        type: 'nicFront',
                      ),
                      _buildUploadButton(
                        label: 'Upload NIC Back',
                        type: 'nicBack',
                      ),
                      _buildUploadButton(
                        label: 'Upload Photo',
                        type: 'photo',
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _showSuccessDialog();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Submit Certification',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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