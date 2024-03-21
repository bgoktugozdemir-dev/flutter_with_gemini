import 'package:flutter/material.dart';
import 'package:flutter_with_gemini/main.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key});

  static const String _aiStudioUrl = 'https://aistudio.google.com/app/apikey';

  @override
  State<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini API'),
      ),
      body: Center(
        child: SizedBox(
          height: size.height * 0.6,
          width: size.width * 0.75,
          child: Column(
            children: [
              const Spacer(),
              const Text('Enter your API Key'),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'AIuLoiUDwX932xnszuYWEvrBBejnBU4uqqNhc',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    FlutterWithGeminiApp.geminiApiKey = value.trim();
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final value = textController.text.trim();

                  if (value.isNotEmpty) {
                    FlutterWithGeminiApp.geminiApiKey = value;
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                ),
                child: const Text('Enter'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => launchUrlString(ApiKeyPage._aiStudioUrl),
                child: const Text('Get your key'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
