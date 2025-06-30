import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslatorService {
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);

  Future<String> translate(String originalText) async {
    final langCode = await languageIdentifier.identifyLanguage(originalText);

    if (langCode != 'en') {
      final sourceLang = TranslateLanguage.values.firstWhere(
        (e) => e.bcpCode == langCode,
        orElse: () => TranslateLanguage.arabic, // fallback
      );

      final translator = OnDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: TranslateLanguage.english,
      );

      final translated = await translator.translateText(originalText);
      await translator.close();
      return translated;
    }
    return originalText;
  }
}
