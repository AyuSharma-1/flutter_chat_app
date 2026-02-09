import 'package:my_chat_app/core/feature/conversation/domain/entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();
}