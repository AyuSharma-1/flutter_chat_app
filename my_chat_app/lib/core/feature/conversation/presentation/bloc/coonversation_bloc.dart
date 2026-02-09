import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/core/feature/conversation/presentation/bloc/conversaation_event.dart';
import 'package:my_chat_app/core/feature/conversation/presentation/bloc/conversation_state.dart';
import 'package:my_chat_app/core/feature/conversation/domain/usecases/fetch_conversation.use_case.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationUseCase fetchConversationUseCase;
  ConversationBloc({required this.fetchConversationUseCase})
    : super(ConversationInitial()) {
    on<ConversationEvent>(_onFetchConversations);
  }
  Future<void> _onFetchConversations(
    ConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    try {
      final conversation = await fetchConversationUseCase();
      print("conversation");
      print(conversation);
      emit(ConversationLoaded(conversation));
    } catch (e) {
      emit(ConversationError("Failed to fetch conversations 234"));
    }
  }
}