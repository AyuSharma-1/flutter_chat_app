import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_chat_app/core/feature/conversation/data/model/conversationModel.dart';

class ConversationRemoteDataSource {
  final String baseUrl = 'http://localhost:5000';
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/conversation'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      List data = responseData['conversations'];
      var x = data.map((json) => ConversationModel.fromJson(json)).toList();
      return x;
    } else {
      throw Exception('Failed to fetch conversations 123');
    }
  }
}
