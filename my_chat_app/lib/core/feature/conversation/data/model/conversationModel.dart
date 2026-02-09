import 'package:my_chat_app/core/feature/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required super.id,
    required super.participants,
    required super.lastMessage,
    required super.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    // Parse participants list
    List<Participant> participants = [];
    if (json['participants'] != null) {
      participants = (json['participants'] as List)
          .where((p) => p != null) // Filter out null participants
          .map(
            (p) => Participant(
              id: p['_id'] ?? '',
              username: p['username'] ?? '',
              email: p['email'] ?? '',
            ),
          )
          .toList();
    }

    // Parse lastMessage (may be null if no messages yet)
    LastMessage? lastMessage;
    if (json['lastMessage'] != null) {
      lastMessage = LastMessage(
        id: json['lastMessage']['_id'] ?? '',
        content: json['lastMessage']['content'] ?? '',
        senderId: json['lastMessage']['senderId'] ?? '',
        createdAt: json['lastMessage']['createdAt'] != null
            ? DateTime.parse(json['lastMessage']['createdAt'])
            : DateTime.now(),
      );
    } else {
      // Default empty message if no lastMessage exists
      lastMessage = LastMessage(
        id: '',
        content: 'No messages yet',
        senderId: '',
        createdAt: DateTime.now(),
      );
    }

    return ConversationModel(
      id: json['_id'] ?? json['id'] ?? '',
      participants: participants,
      lastMessage: lastMessage,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
