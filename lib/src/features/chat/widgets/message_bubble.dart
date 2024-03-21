import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_with_gemini/src/features/chat/domain/models/chat_message.dart';
import 'package:lottie/lottie.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
    this.message, {
    super.key,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxWidth = width * 0.66;

    if (message.from == MessageFrom.ai && message.status == MessageStatus.pending) {
      return Lottie.asset(
        'assets/animations/loading_ai.json',
        height: width / 3,
        alignment: Alignment.centerLeft,
      );
    }

    return Row(
      mainAxisAlignment: message.from == MessageFrom.user ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            constraints: BoxConstraints(maxWidth: maxWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: backgroundColor(context),
            ),
            child: GestureDetector(
              onLongPress: () async {
                await Clipboard.setData(ClipboardData(text: message.text));

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message is copied!')));
                }
              },
              child: MarkdownBody(data: message.text),
            ),
          ),
        )
      ],
    );
  }

  Color backgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (message.from == MessageFrom.ai) {
      return colorScheme.surfaceVariant;
    }

    return switch (message.status) {
      MessageStatus.received => colorScheme.primaryContainer,
      MessageStatus.pending => colorScheme.primaryContainer.withOpacity(0.5),
      MessageStatus.failure => colorScheme.error,
    };
  }
}
