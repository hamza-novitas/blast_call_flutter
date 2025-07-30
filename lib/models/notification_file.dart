import 'notification.dart'; // Adjust path if needed
import 'file.dart'; // Assuming your File class is in file_model.dart

class NotificationFile {
  int? notificationID;
  int? fileID;
  NotificationModel? notification;
  FileModel? file;

  NotificationFile({
    this.notificationID,
    this.fileID,
    this.notification,
    this.file,
  });

  factory NotificationFile.fromJson(Map<String, dynamic> json) {
    return NotificationFile(
      notificationID: json['notificationID'],
      fileID: json['fileID'],
      // You can expand these if you're returning nested data:
      // notification: NotificationModel.fromJson(json['notification']),
      // file: FileModel.fromJson(json['file']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationID': notificationID,
      'fileID': fileID,
      // Add nested objects only if required by your API
    };
  }
}
