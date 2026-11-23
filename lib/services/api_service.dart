import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';
import '../models/user.dart';

/// Simple exception carrying a user friendly message.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Talks to https://dummyjson.com (free dummy API).
class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/recipes?limit=0'))
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
            'Server error (${response.statusCode}). Please try again.');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final list = body['recipes'] as List<dynamic>? ?? [];
      return list
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw const ApiException('Request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
          'No internet connection. Please check your network.');
    } on FormatException {
      throw const ApiException('Invalid data received from server.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Something went wrong. Please try again.');
    }
  }

  Future<AppUser> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
              'expiresInMins': 30,
            }),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return AppUser.fromJson(body);
      }
      throw ApiException(body['message']?.toString() ?? 'Login failed.');
    } on TimeoutException {
      throw const ApiException('Request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
          'No internet connection. Please check your network.');
    } on FormatException {
      throw const ApiException('Invalid data received from server.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Something went wrong. Please try again.');
    }
  }
}
