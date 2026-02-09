import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';

abstract class ChatEvent {}

class LoadMessageEvent extends ChatEvent {
  final String conversationId;
  LoadMessageEvent(this.conversationId);
}

class SendMessageEvent extends ChatEvent {
  final String conversationId;
  final String content;
  final String userId;
  SendMessageEvent(this.conversationId, this.content,this.userId);
}

class ReceivedMessageEvent extends ChatEvent {
  final Map<String, dynamic> message;
  ReceivedMessageEvent(this.message);
}