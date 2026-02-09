import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_chat_app/core/feature/chat/data/model/message_model.dart';
import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageRemoteDataSource {
  final String baseUrl = "http://localhost:5000";
  final _storage = FlutterSecureStorage();

  Future<List<MessageEntity>> fetchMessage(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/message/$conversationId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      List data = responseData['messages'];
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
