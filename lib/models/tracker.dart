import 'recipient.dart';
import 'notification.dart';

class Tracker {
  int? trackerID;
  String createdDate;
  int? cycleNumber;
  String phoneNumber;
  int? status;
  int? recipientID;
  int? notificationID;

  Recipient? recipient;
  NotificationModel? notification;

  Tracker({
    this.trackerID,
    this.createdDate = '',
    this.cycleNumber,
    this.phoneNumber = '',
    this.status,
    this.recipientID,
    this.notificationID,
    this.recipient,
    this.notification,
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      trackerID: json['trackerID'],
      createdDate: json['createdDate'] ?? '',
      cycleNumber: json['cycleNumber'],
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'],
      recipientID: json['recipientID'],
      notificationID: json['notificationID'],
      // recipient: json['recipient'] != null ? Recipient.fromJson(json['recipient']) : null,
      // notification: json['notification'] != null ? NotificationModel.fromJson(json['notification']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trackerID': trackerID,
      'createdDate': createdDate,
      'cycleNumber': cycleNumber,
      'phoneNumber': phoneNumber,
      'status': status,
      'recipientID': recipientID,
      'notificationID': notificationID,
      // Optional: add nested objects if needed
    };
  }
}
