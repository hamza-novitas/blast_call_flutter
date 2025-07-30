import 'dart:convert';
import 'package:blast_caller_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl =
      'http://178.153.95.55/api'; // Replace with actual API URL
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  // Login method
  static Future<void> login(String username, String password) async {
    try {
      // For demo purposes, we're simulating a successful login with demo/password
      if (username == 'demo' && password == 'password') {
        // Store auth token securely
        await storage.write(key: 'auth_token', value: 'demo_token_12345');
        await storage.write(key: 'username', value: username);
        return;
      }

      // In a real app, you would make an actual API call:
      UserViewModel userViewModel =
          UserViewModel(username: username, password: password);

      final response = await http.post(
        Uri.parse('$baseUrl/User/auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'passwordHash': userViewModel.hashPassword().passwordHash,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Store auth token securely
        await storage.write(key: 'auth_token', value: data["token"]);
        await storage.write(key: 'username', value: data["userName"]);
        await storage.write(key: 'roles', value: jsonEncode(data["bcUserRoles"]));
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }

      // For non-demo credentials, throw an error
      // throw Exception('Invalid credentials');
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }

  // Logout method
  static Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'username');
  }

  // Get current user's username
  static Future<String?> getCurrentUsername() async {
    return await storage.read(key: 'username');
  }

  // Example API call to fetch data
  static Future<Map<String, dynamic>> fetchData(String endpoint) async {
    try {
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      // In a real app, you would make an actual API call:
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        await logout();
        throw Exception('Authentication expired');
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      // For demo purposes, return mock data
      return {
        'status': 'success',
        'data': {
          'message': 'This is mock data for $endpoint',
        }
      };
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> postData(
      String endpoint, dynamic payload) async {
    try {
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        await logout();
        throw Exception('Authentication expired');
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
