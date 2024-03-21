import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_gemini/src/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_with_gemini/src/features/chat/widgets/message_bubble.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final messages = state.messages;

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) => MessageBubble(messages[index]),
        );
      },
    );
  }
}
