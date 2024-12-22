class ApiEndpoints{

  static const String baseUrl = "http://127.0.0.1:8000/api/user-management-service";
  static const String baseUrlCustomer = "http://127.0.0.1:8000/api/customer";
  static const String baseUrlExpensess = "http://127.0.0.1:8000/api/Expensess-Management-service";

  // Authentication & User Management
  static const String registerUser = "$baseUrl/auth/register";
  static const String loginUser = "$baseUrl/auth/login";
  static const String logoutUser = "$baseUrl/auth/logout";
  static const String resetPassword = "$baseUrl/auth/reset-password";
  static const String changePassword = "$baseUrl/auth/change-password";

  // Profile Management
  static const String updateProfile = "$baseUrl/auth/profile/update";
  static const String deleteProfile = "$baseUrl/auth/profile/delete";
  static const String getMyProfile = "$baseUrl/auth/profile/me";
  static const String getProfileById = "$baseUrl/auth/profile/get";
  static const String searchProfiles = "$baseUrl/auth/profile/search";

  // Certification Management
  static const String addCertification = "$baseUrl/auth/profile/add-certification";
  static const String updateCertification = "$baseUrl/auth/profile/update-certification";
  static const String deleteCertification = "$baseUrl/auth/profile/delete-certification";
  static const String getCertificationById = "$baseUrl/auth/profile/get-certification";
  static const String searchCertifications = "$baseUrl/auth/profile/search-certification";

  // Income Sources Management
  static const String addIncomeSource = "$baseUrl/income-sources/add";
  static const String updateIncomeSource = "$baseUrl/income-sources/update";
  static const String deleteIncomeSource = "$baseUrl/income-sources/delete";
  static const String searchIncomeSources = "$baseUrl/income-sources/search";
  static const String getIncomeSourceById = "$baseUrl/income-sources/get";

  // Notifications & Messaging
  static const String sendNotification = "$baseUrl/notify/send";
  static const String sendBulkNotifications = "$baseUrl/notify/send-bulk";


  // Customer Spending Analysis bot & systamatic instings
  static const String getBotgeneratedInstings = "$baseUrlCustomer/consolidated-data";
  static const String getSystemGeneratedInstings = "$baseUrlCustomer/current-month-data";

  // Expensess Adding
  static const String getAllReasons = "$baseUrlExpensess/reasons/all";
  static const String addAllExpensess = "$baseUrlExpensess/add";
  static const String updateAllExpensess = "$baseUrlExpensess/update";
  static const String deleteAllExpensess = "$baseUrlExpensess/delete";
  static const String getAllExpensess = "$baseUrlExpensess/all";

  // Meetings Handling 
  static const String getAllprofessionals = "$baseUrlCustomer/professionals/all";
  static const String getAllprofessionalTypes = "$baseUrlCustomer/professional-types";
  static const String bookMeeting = "$baseUrlCustomer/book-meeting"; 
  static const String getPendingMeetings = "$baseUrlCustomer/meetings/all"; 
  static const String getInocompleatedPaidMeetings = "$baseUrlCustomer/meetings/InCompleatePayments"; 
}