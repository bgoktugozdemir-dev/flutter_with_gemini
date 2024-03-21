part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.errorMessage = '',
    this.status = ChatStatus.initial,
  });

  final List<ChatMessage> messages;
  final String errorMessage;
  final ChatStatus status;

  @override
  List<Object> get props => [messages, errorMessage, status];

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? errorMessage,
    ChatStatus? status,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}

enum ChatStatus { initial, loading, failure }
