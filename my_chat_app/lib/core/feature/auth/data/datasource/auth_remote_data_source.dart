import 'package:my_chat_app/core/feature/auth/data/model/user_model.dart';
import 'package:my_chat_app/core/feature/auth/domain/entities/user_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthRemoteDataSource {
  final String baseURL = kIsWeb
      ? 'http://localhost:5000'
      : 'http://[IP_ADDRESS]';

  Map<String, dynamic> _decodeBody(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Invalid server response');
    }
  }

  UserEntity _handleResponse(http.Response response) {
    final body = _decodeBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body['message'] ?? 'Request failed';
      throw Exception(message);
    }
    final payload = body['user'] is Map<String, dynamic>
        ? body['user'] as Map<String, dynamic>
        : body;
    return UserModel.fromJson(payload);
  }

  Future<UserEntity> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<UserEntity> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseURL/auth/register"),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    // return UserModel.fromJson(jsonDecode(response.body)['user'])
    return _handleResponse(response);
  }
}
