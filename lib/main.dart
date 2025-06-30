import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'services/api_service.dart';

void main() => runApp(const MaterialApp(home: SpeechScreen()));

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});
  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final voice = SpeechToText();
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  OnDeviceTranslator? translator;

  bool mic = false;
  String text = '';
  String name = '';
  String phone = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await voice.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
  }

  Future<String> _translateIfNeeded(String originalText) async {
    try {
      final langCode = await languageIdentifier.identifyLanguage(originalText);
      print("Detected language: $langCode");

      if (langCode != 'en') {
        final sourceLang = TranslateLanguage.values.firstWhere(
          (e) => e.bcpCode == langCode,
          orElse: () => TranslateLanguage.english,
        );

        translator = OnDeviceTranslator(
          sourceLanguage: sourceLang,
          targetLanguage: TranslateLanguage.english,
        );

        final translated = await translator!.translateText(originalText);
        print("Translated to English: $translated");
        return translated;
      }
    } catch (e) {
      print("Translation failed: $e");
    }
    return originalText;
  }

  Future<void> _listen() async {
    if (mic) {
      await voice.stop();
      setState(() => mic = false);
    } else {
      setState(() {
        mic = true;
        text = '';
        name = '';
        phone = '';
        loading = false;
      });

      voice.listen(
        onResult: (r) async {
          setState(() => text = r.recognizedWords);

          if (r.finalResult) {
            setState(() => loading = true);

            try {
              final translated = await _translateIfNeeded(text);
              final result = await ApiService.extractEntities(translated);
              setState(() {
                name = result['name'] ?? 'Not found';
                phone = result['phone'] ?? 'Not found';
              });
            } catch (e) {
              setState(() {
                name = 'Error';
                phone = 'Error';
              });
              print('Error processing speech: $e');
            } finally {
              translator?.close();
              setState(() {
                mic = false;
                loading = false;
              });
            }
          }
        },
        localeId: 'en_US', // Always default to English speech model (supports many accents)
      );
    }
  }

  @override
  void dispose() {
    voice.stop();
    translator?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Speech → Name & Phone Extractor')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text.isEmpty ? 'Tap the mic and speak...' : text,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (loading) const CircularProgressIndicator(),
              if (!loading) ...[
                Text('👤 Name: $name', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('📞 Phone: $phone', style: const TextStyle(fontSize: 18)),
              ],
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(mic ? Icons.mic_off : Icons.mic),
                label: Text(mic ? 'Stop' : 'Start Listening'),
                onPressed: _listen,
              ),
            ],
          ),
        ),
      );
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'bloc/speech_bloc.dart';
// import 'bloc/speech_repository.dart';
// import 'bloc/speech_event.dart';
// import 'bloc/speech_state.dart';
// import 'UI/speech_screen.dart';

// void main() {
//   runApp(
//     RepositoryProvider(
//       create: (_) => SpeechRepository(),
//       child: BlocProvider(
//         create: (context) => SpeechBloc(context.read<SpeechRepository>()),
//         child: const MaterialApp(home: SpeechScreen()),
//       ),
//     ),
//   );
// }

