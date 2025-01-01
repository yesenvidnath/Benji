class ConvertProfessionalModel {
  final String professionalType;
  final List<Map<String, dynamic>> certificates;

  ConvertProfessionalModel({
    required this.professionalType,
    required this.certificates,
  });

  Future<Map<String, dynamic>> toMultipartFormData() async {
    final Map<String, dynamic> formData = {
      'professionalType': professionalType,
    };

    for (int i = 0; i < certificates.length; i++) {
      formData['certificates[$i][certificateImage]'] = certificates[i]['certificateImage'];
      formData['certificates[$i][certificateName]'] = certificates[i]['certificateName'];
      formData['certificates[$i][certificateDate]'] = certificates[i]['certificateDate'];
    }

    return formData;
  }
}
