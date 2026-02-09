import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.content,
    required super.senderId,
    required super.conversationId,
    required super.createdAt,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      conversationId: json['conversationId'] ?? '',
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }
}
