import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class SpeechService {
  final SpeechToText _voice = SpeechToText();
  final LanguageIdentifier _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  OnDeviceTranslator? _translator;

  Future<void> init() async {
    await _voice.initialize();
  }

  void listen(Function(String) onResult) {
    _voice.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: 'en_US',
    );
  }

  Future<void> stop() async {
    await _voice.stop();
  }

  Future<String> translateIfNeeded(String text) async {
    try {
      final lang = await _languageIdentifier.identifyLanguage(text);
      if (lang != 'en') {
        final sourceLang = TranslateLanguage.values.firstWhere(
          (e) => e.bcpCode == lang,
          orElse: () => TranslateLanguage.english,
        );
        _translator = OnDeviceTranslator(
          sourceLanguage: sourceLang,
          targetLanguage: TranslateLanguage.english,
        );
        final translated = await _translator!.translateText(text);
        await _translator?.close();
        return translated;
      }
    } catch (_) {}
    return text;
  }
}
