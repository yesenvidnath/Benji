import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/common/header_navigator.dart';
import '../../../widgets/common/footer_navigator.dart';
import '../../controllers/convert_controller.dart';
import '../../data/models/convert_model.dart';

class CertificationUploadScreen extends StatefulWidget {
  const CertificationUploadScreen({Key? key}) : super(key: key);

  @override
  _CertificationUploadScreenState createState() => _CertificationUploadScreenState();
}

class _CertificationUploadScreenState extends State<CertificationUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _picker = ImagePicker();
  final _certificationNameController = TextEditingController();
  final _typeOfProfessionalController = TextEditingController();

  DateTime _certificationDate = DateTime.now();
  bool _hasUploadedImage = false;
  bool _isLoading = false;
  dynamic _currentImageFile;
  Uint8List? _webImage;
  
  final List<CertificationModel> _certifications = [];
  late ConvertController _convertController;

  @override
  void initState() {
    super.initState();
    _convertController = Provider.of<ConvertController>(context, listen: false);
  }

  @override
  void dispose() {
    _certificationNameController.dispose();
    _typeOfProfessionalController.dispose();
    super.dispose();
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

  Future<void> _showCertificationDatePicker() async {
    DateTime? tempDate = _certificationDate;
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
                      setState(() => _certificationDate = tempDate!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _certificationDate,
                  maximumDate: DateTime.now(),
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            _currentImageFile = bytes;
            _hasUploadedImage = true;
          });
        } else {
          setState(() {
            _currentImageFile = File(pickedFile.path);
            _hasUploadedImage = true;
          });
        }
      }
    } catch (e) {
      setState(() {
        _hasUploadedImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
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
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
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

  Widget _buildImagePreview() {
    if (!_hasUploadedImage) return const SizedBox();

    if (kIsWeb) {
      return Image.memory(
        _currentImageFile,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(child: Text('Error loading image')),
          );
        },
      );
    } else {
      return Image.file(
        _currentImageFile,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(child: Text('Error loading image')),
          );
        },
      );
    }
  }

  Widget _buildUploadButton() {
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
      child: Column(
        children: [
          ListTile(
            onTap: _showImageSourceDialog,
            leading: Icon(
              _hasUploadedImage ? Icons.check_circle : Icons.upload_file,
              color: _hasUploadedImage ? AppColors.success : AppColors.primary,
            ),
            title: Text(
              'Upload Certificate Image',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _hasUploadedImage ? AppColors.success : AppColors.primary,
              ),
            ),
            trailing: Icon(CupertinoIcons.chevron_right, 
              color: AppColors.primary.withOpacity(0.5)),
          ),
          if (_hasUploadedImage) 
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImagePreview(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCertificationCard(CertificationModel cert, int index) {
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
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              cert.name,
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Type: ${cert.type}'),
                Text('Date: ${cert.date.day}/${cert.date.month}/${cert.date.year}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400]),
              onPressed: () {
                setState(() {
                  _certifications.removeAt(index);
                });
              },
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: kIsWeb
                  ? Image.memory(cert.imageFile, fit: BoxFit.cover)
                  : Image.file(cert.imageFile, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  void _addCertification() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_hasUploadedImage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a certificate image')),
        );
        return;
      }

      setState(() {
        _certifications.add(CertificationModel(
          name: _certificationNameController.text,
          type: _typeOfProfessionalController.text,
          date: _certificationDate,
          imageFile: _currentImageFile,
        ));
        
        _certificationNameController.clear();
        _hasUploadedImage = false;
        _currentImageFile = null;
      });
    }
  }

  Future<void> _uploadCertifications() async {
    try {
      setState(() => _isLoading = true);

      final List<Map<String, dynamic>> certificatesData = _certifications.map((cert) {
        dynamic imageData;
        if (kIsWeb) {
          imageData = cert.imageFile; // Uint8List for web
        } else {
          final File imageFile = cert.imageFile as File;
          imageData = imageFile.readAsBytesSync(); // Binary data for mobile
        }

        return {
          'certificateImage': imageData,
          'certificateName': cert.name,
          'certificateDate': cert.date.toIso8601String(),
        };
      }).toList();

      final model = ConvertProfessionalModel(
        professionalType: _typeOfProfessionalController.text,
        certificates: certificatesData,
      );

      await _convertController.convertToProfessional(model);
      
      setState(() => _isLoading = false);
      _showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading certifications: $e')),
      );
    }
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
                Icon(Icons.check_circle, color: AppColors.success, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Congratulations!',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your certifications have been submitted successfully.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
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
                          controller: _typeOfProfessionalController,
                          style: AppTextStyles.input,
                          decoration: InputDecoration(
                            labelText: 'Professional Type',
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
                        onTap: _showCertificationDatePicker,
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
                                'Certification Date: ${_certificationDate.day}/${_certificationDate.month}/${_certificationDate.year}',
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

                      _buildUploadButton(),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _addCertification,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Add Certification',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      if (_certifications.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Added Certifications',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _certifications.length,
                          itemBuilder: (context, index) {
                            return _buildCertificationCard(_certifications[index], index);
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading 
                              ? null 
                              : () {
                                  if (_certifications.isNotEmpty) {
                                    _uploadCertifications();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please add at least one certification'),
                                      ),
                                    );
                                  }
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Submit All Certifications',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),
                      ],
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

class CertificationModel {
  final String name;
  final String type;
  final DateTime date;
  final dynamic imageFile;

  CertificationModel({
    required this.name,
    required this.type,
    required this.date,
    required this.imageFile,
  });
}