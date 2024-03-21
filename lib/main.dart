import 'package:flutter/material.dart';
import 'package:flutter_with_gemini/src/features/authorization/api_key_page.dart';
import 'package:flutter_with_gemini/src/features/chat/chat_page.dart';

void main() {
  runApp(const FlutterWithGeminiApp());
}

class FlutterWithGeminiApp extends StatelessWidget {
  const FlutterWithGeminiApp({super.key});

  /// The API key to use when accessing the Gemini API.
  ///
  /// To learn how to generate and specify this key,
  /// check out the README file of this sample.
  static final ValueNotifier<String> _geminiApiKeyNotifier = ValueNotifier(const String.fromEnvironment('API_KEY'));
  static String get geminiApiKey => _geminiApiKeyNotifier.value;
  static set geminiApiKey(String value) => _geminiApiKeyNotifier.value = value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 💙 Gemini',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF027DFD),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ValueListenableBuilder(
        valueListenable: _geminiApiKeyNotifier,
        builder: (context, geminiApiKey, child) {
          if (geminiApiKey.isNotEmpty) {
            return const ChatPage();
          } else {
            return const ApiKeyPage();
          }
        },
      ),
    );
  }
}
