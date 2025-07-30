import 'notification.dart';

class NotificationPriority {
  int notificationID;
  int priority;
  int type;

  NotificationModel? notification;

  NotificationPriority({
    required this.notificationID,
    required this.priority,
    required this.type,
    this.notification,
  });

  factory NotificationPriority.fromJson(Map<String, dynamic> json) {
    return NotificationPriority(
      notificationID: json['notificationID'],
      priority: json['priority'],
      type: json['type'],
      // notification: json['notification'] != null
      //     ? NotificationModel.fromJson(json['notification'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationID': notificationID,
      'priority': priority,
      'type': type,
      // Add 'notification': notification?.toJson() if needed
    };
  }
}
