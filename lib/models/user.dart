import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  String username;
  String passwordHash;

  User({required this.username, required this.passwordHash});
}

class UserViewModel {
  String username;
  String password;

  UserViewModel({required this.username, required this.password});

  // Method to hash password and assign to user
  User hashPassword() {
    List<int> bytes = utf8.encode(this.password); // Convert password to bytes
    Digest hash = sha512.convert(bytes); // Perform SHA-512 hashing
    return User(username: username, passwordHash: hash.toString()); // Return User object with hashed password
  }
}