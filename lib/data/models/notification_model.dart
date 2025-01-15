class NotificationModel {
  final int notificationID;
  final int userID;
  final String type;
  final String message;
  final int isRead;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.notificationID,
    required this.userID,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationID: json['notification_ID'],
      userID: json['user_ID'],
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_ID': notificationID,
      'user_ID': userID,
      'type': type,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
