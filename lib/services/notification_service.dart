import 'dart:convert';
import 'dart:io';
import 'package:blast_caller_app/models/notification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart'; // <-- Import your ApiService

class NotificationService {
  final http.Client client;
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  NotificationService({http.Client? httpClient})
      : client = httpClient ?? http.Client();

  Future<Map<String, dynamic>?> saveNotification(NotificationModel notification) async {
    try {
      print("TEST ============ '${jsonEncode(notification)}'");
      final response = await client.post(
        Uri.parse('${ApiService.baseUrl}/Notification'),
        headers: await _headers(),
        body: jsonEncode(notification),
      );

      return _decode(response);
    } catch (e, stacktrace) {
      // You can also log the error/stacktrace here using a logger
      print('TEST Error in saveNotification: $e');
      print(stacktrace);
      return null;
    }
  }

  Future<void> updateNotification(dynamic notification, int savingStep) async {
    try {
      final url = savingStep == 4
          ? '${ApiService.baseUrl}/Notification/${notification['notificationID']}/config'
          : '${ApiService.baseUrl}/Notification';

      final response = savingStep == 4
          ? await client.post(
        Uri.parse(url),
        headers: await _headers(),
        body: jsonEncode(notification),
      )
          : await client.put(
        Uri.parse(url),
        headers: await _headers(),
        body: jsonEncode(notification),
      );
      print("TEST responseresponseresponse ${jsonDecode(response.body)}");
      // return _decode(response);
    } catch (e, stacktrace) {
      print('TEST Error in updateNotification: $e');
      print(stacktrace);
      // return null;
    }
  }

  Future<void> updateNotificationStatus(int id, int status,
      {String? note, String? scheduledDate}) async {
    final body = {
      'Status': status,
      if (note != null) 'Note': note,
      if (scheduledDate != null) 'ScheduledDate': scheduledDate,
    };

    final response = await client.put(
      Uri.parse('${ApiService.baseUrl}/Notification/Status/$id'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    print("TEST responseresponseresponse ${jsonDecode(response.body)}");
    // return _decode(response);
  }

  Future<Map<String, dynamic>> runNotification(int? notificationID) async {
    try {
      if (notificationID == null) {
        throw ArgumentError('Notification ID cannot be null');
      }

      final response = await client.post(
        Uri.parse('${ApiService.baseUrl}/Notification/Run/$notificationID'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // debugPrint('Notification $notificationID executed successfully: $decoded');
        return decoded;
      } else {
        throw HttpException(
          'Failed to run notification (Status: ${response.statusCode})',
          uri: response.request?.url,
        );
      }
    } on FormatException catch (e) {
      throw FormatException('Invalid API response format', e);
    } on http.ClientException catch (e) {
      throw HttpException('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchNotificationStatistics(
      int? notificationID) async {
    final response = await client.get(
      Uri.parse('${ApiService.baseUrl}/Notification/Statistics/$notificationID'),
      headers: await _headers()
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>?> addNotificationRecipientsByFilter(
      int notificationID, Map<String, dynamic> filter) async {
    final response = await client.post(
      Uri.parse('${ApiService.baseUrl}/NotificationRecipient/by-filter/$notificationID'),
      headers: await _headers(),
      body: jsonEncode(filter),
    );
    return _decode(response);
  }

  Future<void> addNotificationFiles(int notificationID, List<dynamic> fileIDs) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiService.baseUrl}/NotificationFile/$notificationID'),
        headers: await _headers(),
        body: jsonEncode(fileIDs),
      );
      print("TEST responseresponseresponse ${jsonDecode(response.body)}");
      // return _decode(response);
    } catch (e, stacktrace) {
      print('Error in addNotificationFiles: $e');
      print(stacktrace);
      // return null;
    }
  }

  Future<Map<String, dynamic>?> getAllFiles({bool includeDisabled = false}) async {
    try {
      final uri = Uri.parse('${ApiService.baseUrl}/File/type/all')
          .replace(queryParameters: {'includeDisabled': includeDisabled.toString()});

      final response = await client.get(uri, headers: await _headers());
      return _decode(response);
    } catch (e, stacktrace) {
      print('Error in getAllFiles: $e');
      print(stacktrace);
      return null;
    }
  }

  // Utility Methods
  Future<Map<String, String>> _headers() async {
    final token = await storage.read(key: 'auth_token');

    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic>? _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      print('HTTP ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
