import 'package:equatable/equatable.dart';
import 'package:my_chat_app/core/feature/conversation/domain/entities/conversation_entity.dart'
    show ConversationEntity;

abstract class ConversationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {
  @override
  List<Object?> get props => [];
}

class ConversationLoading extends ConversationState {
  @override
  List<Object?> get props => [];
}

class ConversationLoaded extends ConversationState {
  final List<ConversationEntity> conversations;
  ConversationLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationError extends ConversationState {
  final String message;
  ConversationError(this.message);

  @override
  List<Object?> get props => [message];
}
