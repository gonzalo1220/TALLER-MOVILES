import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // API base
  static const _baseUrl = 'https://parking.visiontic.com.co/api';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Attempts login with [email] and [password].
  /// On success saves tokens and user info locally and returns a map with raw response.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/login');
    try {
      final resp = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(resp.body);

        // Try to detect tokens and user data in common locations
        String? accessToken;
        String? refreshToken;
        Map<String, dynamic>? user;

        if (json.containsKey('access_token')) {
          accessToken = json['access_token'] as String?;
        }
        if (json.containsKey('token')) {
          accessToken = accessToken ?? json['token'] as String?;
        }
        if (json.containsKey('refresh_token')) {
          refreshToken = json['refresh_token'] as String?;
        }

        // sometimes the payload is under `data`
        if ((accessToken == null) && json['data'] is Map) {
          final data = json['data'] as Map<String, dynamic>;
          accessToken =
              data['access_token'] as String? ?? data['token'] as String?;
          refreshToken = refreshToken ?? data['refresh_token'] as String?;
          if (data['user'] is Map<String, dynamic>) {
            user = Map<String, dynamic>.from(data['user']);
          }
        }

        // user might be top-level
        if (user == null) {
          if (json['user'] is Map<String, dynamic>) {
            user = Map<String, dynamic>.from(json['user']);
          }
        }

        // Save tokens and user info if available
        if (accessToken != null) {
          await _secureStorage.write(key: 'access_token', value: accessToken);
        }
        if (refreshToken != null) {
          await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        }

        final prefs = await SharedPreferences.getInstance();
        if (user != null) {
          // Save non-sensitive user info in shared preferences
          if (user['name'] != null) {
            await prefs.setString('name', user['name'].toString());
          }
          if (user['email'] != null) {
            await prefs.setString('email', user['email'].toString());
          }
        } else {
          // fallback: if response contains email/name at top-level
          if (json['email'] != null) {
            await prefs.setString('email', json['email'].toString());
          }
          if (json['name'] != null) {
            await prefs.setString('name', json['name'].toString());
          }
        }

        return json;
      } else if (resp.statusCode == 401) {
        throw Exception('Credenciales inválidas (401)');
      } else {
        throw Exception(
          'Error del servidor: ${resp.statusCode} - ${resp.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Register a new user. Attempts to POST name/email/password to the API.
  /// On success behaves similarly to login: will store tokens and user info when present.
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    // Try common registration endpoint; adjust if your API uses another path
    final uri = Uri.parse('$_baseUrl/register');
    try {
      final resp = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(resp.body);

        // If the API returns tokens or user data, reuse logic from login
        // Try to detect tokens
        String? accessToken;
        String? refreshToken;
        Map<String, dynamic>? user;

        if (json.containsKey('access_token')) {
          accessToken = json['access_token'] as String?;
        }
        if (json.containsKey('token')) {
          accessToken = accessToken ?? json['token'] as String?;
        }
        if (json.containsKey('refresh_token')) {
          refreshToken = json['refresh_token'] as String?;
        }

        if (json['data'] is Map) {
          final data = json['data'] as Map<String, dynamic>;
          accessToken =
              accessToken ??
              data['access_token'] as String? ??
              data['token'] as String?;
          refreshToken = refreshToken ?? data['refresh_token'] as String?;
          if (data['user'] is Map<String, dynamic>) {
            user = Map<String, dynamic>.from(data['user']);
          }
        }

        if (user == null && json['user'] is Map<String, dynamic>) {
          user = Map<String, dynamic>.from(json['user']);
        }

        // Save tokens if returned
        if (accessToken != null) {
          await _secureStorage.write(key: 'access_token', value: accessToken);
        }
        if (refreshToken != null) {
          await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        }

        final prefs = await SharedPreferences.getInstance();
        if (user != null) {
          if (user['name'] != null) {
            await prefs.setString('name', user['name'].toString());
          }
          if (user['email'] != null) {
            await prefs.setString('email', user['email'].toString());
          }
        } else {
          // fallback to provided registration fields
          await prefs.setString('name', name);
          await prefs.setString('email', email);
        }

        return json;
      } else if (resp.statusCode == 400) {
        throw Exception('Datos inválidos para registro (400) - ${resp.body}');
      } else {
        throw Exception(
          'Error del servidor: ${resp.statusCode} - ${resp.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Returns whether an access token is stored.
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null && token.isNotEmpty;
  }

  /// Read stored user info (name,email) from SharedPreferences.
  Future<Map<String, String?>> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    return {'name': name, 'email': email};
  }

  /// Clears stored tokens and shared preferences user info.
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
  }
}
