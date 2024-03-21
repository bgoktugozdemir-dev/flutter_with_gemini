import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_gemini/main.dart';
import 'package:flutter_with_gemini/src/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_with_gemini/src/features/chat/widgets/bottom_message_input_bar.dart';
import 'package:flutter_with_gemini/src/features/chat/widgets/chat_view.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 💙 Gemini'),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (_) {
            final generativeModel = GenerativeModel(
              model: 'gemini-pro',
              apiKey: FlutterWithGeminiApp.geminiApiKey,
            );
            // final generativeVisionModel = GenerativeModel(
            //   model: 'gemini-pro-vision',
            //   apiKey: FlutterWithGeminiApp.geminiApiKey,
            // );
            final chatSession = generativeModel.startChat();

            return ChatBloc(
              generativeModel: generativeModel,
              chatSession: chatSession,
            );
          },
          child: const ChatScreen(),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ScrollController scrollController;
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ChatStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      child: BlocListener<ChatBloc, ChatState>(
        listenWhen: (previous, current) => previous.messages != current.messages,
        listener: (context, state) {
          scrollToBottom();
        },
        child: Column(
          children: [
            Expanded(
              child: ChatView(
                scrollController: scrollController,
              ),
            ),
            BottomMessageInputBar(textController: textController)
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCirc,
        );
      },
    );
  }
}


