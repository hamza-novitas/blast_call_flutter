import 'user.dart';
import 'notification_file.dart';

class FileModel {
  int? fileID;
  String fileName;
  int? type;
  String url;
  String src;
  String createdDate;
  int? creatorID;
  User? creator;
  List<NotificationFile>? notificationFiles;
  bool isDefault;
  bool isEnabled;

  FileModel({
    this.fileID,
    this.fileName = '',
    this.type,
    this.url = '',
    this.src = '',
    this.createdDate = '',
    this.creatorID,
    this.creator,
    this.notificationFiles,
    this.isDefault = false,
    this.isEnabled = true,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileID: json['fileID'],
      fileName: json['fileName'] ?? '',
      type: json['type'],
      url: json['url'] ?? '',
      src: json['src'] ?? '',
      createdDate: json['createdDate'] ?? '',
      creatorID: json['creatorID'],
      // Optional nested deserialization
      // creator: json['creator'] != null ? User.fromJson(json['creator']) : null,
      // notificationFiles: json['notificationFiles'] != null
      //     ? (json['notificationFiles'] as List)
      //         .map((e) => NotificationFile.fromJson(e))
      //         .toList()
      //     : null,
      isDefault: json['isDefault'] ?? false,
      isEnabled: json['isEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileID': fileID,
      'fileName': fileName,
      'type': type,
      'url': url,
      'src': src,
      'createdDate': createdDate,
      'creatorID': creatorID,
      'isDefault': isDefault,
      'isEnabled': isEnabled,
      // Add nested serialization if needed
    };
  }
}
