import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';

abstract class ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<MessageEntity> messages;
  ChatLoadedState(this.messages);
}

class ChatErrorState extends ChatState {
  final String message;
  ChatErrorState(this.message);
}