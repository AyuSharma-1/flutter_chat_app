import 'package:my_chat_app/core/feature/chat/data/datasource/message_remote_data_source.dart';
import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';
import 'package:my_chat_app/core/feature/chat/domain/repository/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;
  MessageRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<MessageEntity>> fetchMessage(String conversationId) async{
    return await remoteDataSource.fetchMessage(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
