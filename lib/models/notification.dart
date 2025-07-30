import 'user.dart';
import 'notification_recipient.dart';
import 'tracker.dart';
import 'notification_file.dart';
import 'notification_lifecycle.dart';
import 'notification_priority.dart';
import 'department.dart';

class NotificationModel {
  int? notificationID = 0;
  String serial = '';
  String name = '';
  int type = 0;
  String email = '';
  String description = '';
  String note = '';
  bool vipPriority = false;
  int limitAttempts = 0;
  int cycleBaseDelay = 0;
  int delayAmplifier = 1;
  String sms = '';
  int? status;
  int savingStep = 0;
  bool isApprovalRequired = true;
  String createdDate = '';
  String launchDate = '';
  String modifiedDate = '';
  String completedDate = '';
  String scheduledLaunchDate = '';
  int? expirationPeriod;
  int? creatorID;
  int? modifierID;
  int? launcherID;
  int? officerID;
  int? parentID;
  User? creator;
  User? modifier;
  User? launcher;
  Department? department;
  List<NotificationRecipient> notificationRecipients = [];
  List<Tracker> trackers = [];
  List<NotificationFile> notificationFiles = [];
  List<NotificationLifeCycle> notificationLifeCycles = [];
  List<NotificationPriority> notificationPriorities = [];
  bool isScheduled = false;
  String? approvalDate;

  NotificationModel();

  /// Factory constructor to create NotificationModel from a JSON map
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    var prioritiesJson = json['priorities'] as List<dynamic>? ?? [];

    return NotificationModel()
      ..notificationID = json['notificationID'] as int?
      ..serial = json['serial'] ?? ''
      ..name = json['name'] ?? ''
      ..type = json['type'] ?? 0
      ..email = json['email'] ?? ''
      ..description = json['description'] ?? ''
      ..note = json['note'] ?? ''
      ..vipPriority = json['vipPriority'] ?? false
      ..limitAttempts = json['limitAttempts'] ?? 0
      ..cycleBaseDelay = json['cycleBaseDelay'] ?? 0
      ..delayAmplifier = json['delayAmplifier'] ?? 1
      ..sms = json['sms'] ?? ''
      ..status = json['status'] as int?
      ..savingStep = json['savingStep'] ?? 0
      ..isApprovalRequired = json['isApprovalRequired'] ?? true
      ..createdDate = json['createdDate'] ?? ''
      ..launchDate = json['launchDate'] ?? ''
      ..modifiedDate = json['modifiedDate'] ?? ''
      ..completedDate = json['completedDate'] ?? ''
      ..scheduledLaunchDate = json['ScheduledLaunchDate'] ?? ''
      ..expirationPeriod = json['expirationPeriod'] as int?
      ..creatorID = json['creatorID'] as int?
      ..modifierID = json['modifierID'] as int?
      ..launcherID = json['launcherID'] as int?
      ..officerID = json['OfficerID'] as int?
      ..parentID = json['parentID'] as int?
    // TODO: Initialize nested objects if needed:
    // ..creator = json['creator'] != null ? User.fromJson(json['creator']) : null
    // ..modifier = json['modifier'] != null ? User.fromJson(json['modifier']) : null
    // ..launcher = json['launcher'] != null ? User.fromJson(json['launcher']) : null
    // ..department = json['department'] != null ? Department.fromJson(json['department']) : null
      ..notificationPriorities = prioritiesJson.map((p) => NotificationPriority.fromJson(p)).toList()
    // Add other lists similarly if needed
        ;
  }

  /// Serialize logic based on savingStep (mimics TypeScript `serialize`)
  Map<String, dynamic> toJson() {
    switch (savingStep) {
      case 1:
      case 2:
      case 3:
        return {
          'notificationID': notificationID,
          'name': name,
          'description': description,
          'note': note,
          'status': status,
          'sms': sms,
          'email': email,
          'isApprovalRequired': isApprovalRequired,
          'vipPriority': vipPriority,
          'limitAttempts': limitAttempts,
          'savingStep': savingStep,
          'cycleBaseDelay': cycleBaseDelay,
          'delayAmplifier': delayAmplifier,
          'expirationPeriod': expirationPeriod,
          'ScheduledLaunchDate': scheduledLaunchDate,
          'OfficerID': officerID,
        };
      case 4:
        return {
          'notificationID': notificationID,
          'vipPriority': vipPriority,
          'limitAttempts': limitAttempts,
          'savingStep': savingStep,
          'cycleBaseDelay': cycleBaseDelay,
          'delayAmplifier': delayAmplifier,
          'priorities': notificationPriorities.map((p) => p.toJson()).toList(),
        };
      default:
        return {};
    }
  }
}
