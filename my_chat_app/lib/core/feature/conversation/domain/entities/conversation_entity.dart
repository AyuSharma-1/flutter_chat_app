class ConversationEntity {
  final String id;
  final List<Participant> participants;
  final LastMessage lastMessage;
  final DateTime updatedAt;

  ConversationEntity({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
  });
}

class Participant {
  final String id;
  final String username;
  final String email;

  Participant({required this.id, required this.username, required this.email});
}

class LastMessage {
  final String id;
  final String content;
  final String senderId;
  final DateTime createdAt;

  LastMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdAt,
  });
}
