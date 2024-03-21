import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_gemini/src/features/chat/domain/models/chat_message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.generativeModel,
    required this.chatSession,
  }) : super(const ChatState()) {
    on<ChatMessagePromptSent>(_onMessagePromptSent);
  }

  /// For text only input
  final GenerativeModel generativeModel;

  /// For text and image input
  // final GenerativeModel generativeVisionModel;

  final ChatSession chatSession;

  void _onMessagePromptSent(ChatMessagePromptSent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));

    var oldMessages = List<ChatMessage>.from(state.messages);
    var message = ChatMessage.fromUser(text: event.text, status: MessageStatus.received);
    var answer = const ChatMessage.fromAI(text: '', status: MessageStatus.pending);

    emit(
      state.copyWith(
        messages: [
          ...oldMessages,
          message,
          answer,
        ],
      ),
    );

    try {
      final response = await chatSession.sendMessage(Content.text(event.text));

      final text = response.text;

      if (text == null) {
        throw Exception();
      }

      answer = ChatMessage.fromAI(text: response.text!);
      emit(
        state.copyWith(
          messages: [...oldMessages, message, answer],
          status: ChatStatus.initial,
        ),
      );
    } on InvalidApiKey catch (e) {
      emit(
        state.copyWith(
          messages: [
            ...oldMessages,
            message.copyWith(status: MessageStatus.failure),
          ],
          errorMessage: e.message,
          status: ChatStatus.failure,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          messages: [
            ...oldMessages,
            message.copyWith(status: MessageStatus.failure),
          ],
          errorMessage: 'Something went wrong!',
          status: ChatStatus.failure,
        ),
      );
    }
  }
}
