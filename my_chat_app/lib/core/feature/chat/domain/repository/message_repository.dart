import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>>fetchMessage(String conversationId);
  Future<void>sendMessage(MessageEntity message);
}
