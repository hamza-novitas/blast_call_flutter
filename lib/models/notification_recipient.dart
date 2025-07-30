import 'recipient.dart';
import 'group.dart';
import 'department.dart';
import 'person.dart';
import 'notification.dart'; // Adjust the path as necessary

class NotificationRecipient {
  int? notificationRecipientID;
  int? type;
  int? notificationID;
  int? personID;
  int? groupID;
  int? departmentID;

  NotificationModel? notification; // Assuming NotificationModel is already created
  Person? person;
  Group? group;
  Department? department;

  List<Recipient> recipients = [];

  String? level1;
  String? level2;
  String? level3;
  String? level4;

  NotificationRecipient({
    this.notificationRecipientID,
    this.type,
    this.notificationID,
    this.personID,
    this.groupID,
    this.departmentID,
    this.notification,
    this.person,
    this.group,
    this.department,
    this.recipients = const [],
    this.level1,
    this.level2,
    this.level3,
    this.level4,
  });

  // Optional: Add fromJson / toJson if you're dealing with APIs
  factory NotificationRecipient.fromJson(Map<String, dynamic> json) {
    return NotificationRecipient(
      notificationRecipientID: json['notificationRecipientID'],
      type: json['type'],
      notificationID: json['notificationID'],
      personID: json['personID'],
      groupID: json['groupID'],
      departmentID: json['departmentID'],
      level1: json['level_1'],
      level2: json['level_2'],
      level3: json['level_3'],
      level4: json['level_4'],
      // Optional: deserialize person, group, department, recipients if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationRecipientID': notificationRecipientID,
      'type': type,
      'notificationID': notificationID,
      'personID': personID,
      'groupID': groupID,
      'departmentID': departmentID,
      'level_1': level1,
      'level_2': level2,
      'level_3': level3,
      'level_4': level4,
      // Optional: Add nested serialization if needed
    };
  }
}
