import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';
import 'package:my_chat_app/core/feature/chat/domain/repository/message_repository.dart';

class FetchMessageUseCase {
  final MessageRepository messageRepository;
  FetchMessageUseCase({required this.messageRepository});

  Future<List<MessageEntity>> call(String conversationId)async{
    return await messageRepository.fetchMessage(conversationId);
  }
}