import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.text,
    required this.from,
    this.status = MessageStatus.pending,
  });

  const ChatMessage.fromUser({
    required this.text,
    this.status = MessageStatus.received,
  }) : from = MessageFrom.user;

  const ChatMessage.fromAI({
    required this.text,
    this.status = MessageStatus.received,
  }) : from = MessageFrom.ai;

  final String text;
  final MessageFrom from;
  final MessageStatus status;

  @override
  List<Object?> get props => [text, from, status];

  ChatMessage copyWith({
    String? text,
    MessageFrom? from,
    MessageStatus? status,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      from: from ?? this.from,
      status: status ?? this.status,
    );
  }
}

enum MessageFrom { user, ai }

enum MessageStatus { pending, received, failure }
