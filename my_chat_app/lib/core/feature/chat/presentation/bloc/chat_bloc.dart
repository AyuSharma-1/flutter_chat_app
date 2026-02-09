import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_chat_app/core/feature/chat/domain/entity/message_entity.dart';
import 'package:my_chat_app/core/feature/chat/domain/usecase/fetch_message_use_case.dart';
import 'package:my_chat_app/core/feature/chat/presentation/bloc/chat_event.dart';
import 'package:my_chat_app/core/feature/chat/presentation/bloc/chat_state.dart';
import 'package:my_chat_app/core/socket_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessageUseCase fetchMessageUseCase;
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];
  ChatBloc({required this.fetchMessageUseCase}) : super(ChatLoadingState()) {
    on<LoadMessageEvent>(_onLoadMessage);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceivedMessageEvent>(_onReceivedMessage);
  }

  Future<void> _onLoadMessage(
    LoadMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());
    try {
      final messages = await fetchMessageUseCase(event.conversationId);
      _messages.clear();
      _messages.addAll(messages.reversed);
      emit(ChatLoadedState(List.from(_messages)));

      _socketService.socket.emit('joinConversation', event.conversationId);
      _socketService.socket.on(
        'newMessage',
        (data) => {
          print("step1 - receive: $data"),
          add(ReceivedMessageEvent(data)),
        },
      );
    } catch (e) {
      emit(ChatErrorState("Failed to load messages"));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      print("Socket connected: ${_socketService.isConnected}");
      final newMessage = {
        'conversationId': event.conversationId,
        'content': event.content,
        'senderId': event.userId,
      };
      print("Sending message: $newMessage");
      _socketService.socket.emit('sendMessage', newMessage);
    } catch (e) {
      print("Send message error: $e");
      emit(ChatErrorState(e.toString()));
    }
  }

  Future<void> _onReceivedMessage(
    ReceivedMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    print("step2 - receive: ${event.message}");

    final message = MessageEntity(
      id: event.message['_id'] ?? '',
      conversationId: event.message['conversationId'] ?? '',
      content: event.message['content'] ?? '',
      senderId: event.message['senderId'] ?? '',
      createdAt: event.message['createdAt'] ?? DateTime.now().toIso8601String(),
    );
    _messages.insert(0, message);
    emit(ChatLoadedState(List.from(_messages)));
  }
}
