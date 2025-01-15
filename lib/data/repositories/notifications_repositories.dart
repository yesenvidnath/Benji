import '../api/notifications_service.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final NotificationsService _service = NotificationsService();

  Future<List<NotificationModel>> fetchNotifications(String token) async {
    final response = await _service.getNotifications(token);

    if (response['unread_notifications'] != null) {
      return (response['unread_notifications'] as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();
    } else {
      throw Exception('No notifications available');
    }
  }
}
