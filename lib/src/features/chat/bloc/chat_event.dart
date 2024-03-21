part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatMessagePromptSent extends ChatEvent {
  const ChatMessagePromptSent(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}