import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../services/api_service.dart';

class SpeechRepository {
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);

  Future<String> translateIfNeeded(String text) async {
    final langCode = await languageIdentifier.identifyLanguage(text);
    if (langCode != 'en') {
      final sourceLang = TranslateLanguage.values.firstWhere(
        (e) => e.bcpCode == langCode,
        orElse: () => TranslateLanguage.english,
      );
      final translator = OnDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: TranslateLanguage.english,
      );
      final translated = await translator.translateText(text);
      translator.close();
      return translated;
    }
    return text;
  }

  Future<Map<String, String>> extractEntities(String text) async {
    final response = await ApiService.extractEntities(text);
    return {
      'name': response['name'] ?? 'Not found',
      'phone': response['phone'] ?? 'Not found'
    };
  }
}

// import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
// import 'package:google_mlkit_translation/google_mlkit_translation.dart';
// import '../services/api_service.dart';

// class SpeechRepository {
//   final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
//   OnDeviceTranslator? translator;

//   Future<String> translateToEnglish(String originalText) async {
//     final langCode = await languageIdentifier.identifyLanguage(originalText);

//     if (langCode != 'en') {
//       translator = OnDeviceTranslator(
//         sourceLanguage: TranslateLanguage.values.firstWhere(
//           (e) => e.bcpCode == langCode,
//           orElse: () => TranslateLanguage.arabic,
//         ),
//         targetLanguage: TranslateLanguage.english,
//       );

//       final translated = await translator!.translateText(originalText);
//       translator!.close();
//       return translated;
//     }
//     return originalText;
//   }

//   Future<Map<String, dynamic>> extractInfo(String text) async {
//     final translated = await translateToEnglish(text);
//     return await ApiService.extractEntities(translated);
//   }
// }
