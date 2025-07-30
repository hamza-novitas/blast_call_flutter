import 'person.dart';
import 'notification_recipient.dart';
import 'tracker.dart';

class Recipient {
  int? recipientID;
  String name;
  String pid;
  String nid;
  bool isVIP;
  String cellNumber1;
  String cellNumber2;
  String cellNumber3;
  String homeNumber;
  String workNumber;
  String pinCode;
  int? inVacation;
  int? personID;
  int? notificationRecipientID;

  Person? person;
  NotificationRecipient? notificationRecipient;
  List<Tracker> trackers;
  int? finalStatus;

  Recipient({
    this.recipientID,
    this.name = '',
    this.pid = '',
    this.nid = '',
    this.isVIP = false,
    this.cellNumber1 = '',
    this.cellNumber2 = '',
    this.cellNumber3 = '',
    this.homeNumber = '',
    this.workNumber = '',
    this.pinCode = '',
    this.inVacation,
    this.personID,
    this.notificationRecipientID,
    this.person,
    this.notificationRecipient,
    this.trackers = const [],
    this.finalStatus,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      recipientID: json['recipientID'],
      name: json['name'] ?? '',
      pid: json['pid'] ?? '',
      nid: json['nid'] ?? '',
      isVIP: json['isVIP'] ?? false,
      cellNumber1: json['cellNumber1'] ?? '',
      cellNumber2: json['cellNumber2'] ?? '',
      cellNumber3: json['cellNumber3'] ?? '',
      homeNumber: json['homeNumber'] ?? '',
      workNumber: json['workNumber'] ?? '',
      pinCode: json['pinCode'] ?? '',
      inVacation: json['inVacation'],
      personID: json['personID'],
      notificationRecipientID: json['notificationRecipientID'],
      finalStatus: json['finalStatus'],
      // Uncomment if you're using nested models from backend:
      // person: json['person'] != null ? Person.fromJson(json['person']) : null,
      // notificationRecipient: json['notificationRecipient'] != null
      //     ? NotificationRecipient.fromJson(json['notificationRecipient'])
      //     : null,
      // trackers: (json['trackers'] as List?)?.map((e) => Tracker.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipientID': recipientID,
      'name': name,
      'pid': pid,
      'nid': nid,
      'isVIP': isVIP,
      'cellNumber1': cellNumber1,
      'cellNumber2': cellNumber2,
      'cellNumber3': cellNumber3,
      'homeNumber': homeNumber,
      'workNumber': workNumber,
      'pinCode': pinCode,
      'inVacation': inVacation,
      'personID': personID,
      'notificationRecipientID': notificationRecipientID,
      'finalStatus': finalStatus,
      // Add nested object serialization if needed
    };
  }

  /// Helper to populate fields from a `Person` object
  void fillFromPerson(Person person) {
    name = person.nameAr;
    pid = person.pid;
    cellNumber1 = person.cellNumber1;
    isVIP = person.isVIP;
    personID = person.personID;
    this.person = person;
  }
}
