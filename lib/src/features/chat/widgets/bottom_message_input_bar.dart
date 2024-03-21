import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_gemini/src/features/chat/bloc/chat_bloc.dart';

class BottomMessageInputBar extends StatelessWidget {
  const BottomMessageInputBar({
    required this.textController,
    super.key,
  });

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
        child: Row(
          children: [
            Expanded(
              child: _MessageInput(textController),
            ),
            const SizedBox(width: 16),
            _SendButton(textController),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput(this.textController);

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return TextField(
          controller: textController,
          minLines: 1,
          maxLines: 5,
          textInputAction: TextInputAction.send,
          onSubmitted: state.status != ChatStatus.loading
              ? (message) {
                  if (message.trim().isNotEmpty) {
                    textController.clear();
                    context.read<ChatBloc>().add(ChatMessagePromptSent(message));
                  }
                }
              : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            hintText: 'Enter a promt here',
            filled: true,
            fillColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
            border: inputBorder(context),
            focusedBorder: inputBorder(context),
          ),
        );
      },
    );
  }

  OutlineInputBorder inputBorder(BuildContext context) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
}

class _SendButton extends StatelessWidget {
  const _SendButton(this.textController);

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return IconButton(
          onPressed: state.status != ChatStatus.loading
              ? () {
                  final message = textController.text;

                  if (message.trim().isNotEmpty) {
                    textController.clear();
                    context.read<ChatBloc>().add(ChatMessagePromptSent(message));
                  }
                }
              : null,
          icon: const Icon(Icons.send),
        );
      },
    );
  }
}
