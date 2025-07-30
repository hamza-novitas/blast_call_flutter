import 'notification.dart';
import 'user.dart';

class NotificationLifeCycle {
  int? notificationLifeCycleID;
  int? status;
  String note;
  String createdDate;
  int? notificationID;
  int? bcUserID;

  NotificationModel? notification;
  User? bcUser;

  NotificationLifeCycle({
    this.notificationLifeCycleID,
    this.status,
    this.note = '',
    this.createdDate = '',
    this.notificationID,
    this.bcUserID,
    this.notification,
    this.bcUser,
  });

  factory NotificationLifeCycle.fromJson(Map<String, dynamic> json) {
    return NotificationLifeCycle(
      notificationLifeCycleID: json['notificationLifeCycleID'],
      status: json['status'],
      note: json['note'] ?? '',
      createdDate: json['createdDate'] ?? '',
      notificationID: json['notificationID'],
      bcUserID: json['bcUserID'],
      // Uncomment below if you're returning full user or notification objects from the backend
      // notification: json['notification'] != null
      //     ? NotificationModel.fromJson(json['notification'])
      //     : null,
      // bcUser: json['bcUser'] != null ? User.fromJson(json['bcUser']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationLifeCycleID': notificationLifeCycleID,
      'status': status,
      'note': note,
      'createdDate': createdDate,
      'notificationID': notificationID,
      'bcUserID': bcUserID,
      // Add nested serialization if needed
    };
  }
}
