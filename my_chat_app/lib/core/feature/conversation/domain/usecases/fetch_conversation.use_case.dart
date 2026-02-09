import 'package:my_chat_app/core/feature/conversation/domain/entities/conversation_entity.dart';
import 'package:my_chat_app/core/feature/conversation/domain/repositories/conversation_repository.dart';

class FetchConversationUseCase {
  final ConversationRepository repository;

  FetchConversationUseCase(this.repository);

  Future<List<ConversationEntity>> call() async {
    return await repository.fetchConversations();
  } 
}