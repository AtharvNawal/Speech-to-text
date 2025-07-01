import '../services/speech_service.dart';
import '../services/api_service.dart';

class SpeechRepository {
  final SpeechService _speechService = SpeechService();

  Future<void> startListening(Function(String) onResult) async {
    await _speechService.init();
    _speechService.listen(onResult);
  }

  Future<void> stopListening() async {
    await _speechService.stop();
  }

  Future<Map<String, String>> processSpeech(String text) async {
    final translated = await _speechService.translateIfNeeded(text);
    final result = await ApiService.extractEntities(translated);
    return {
      'name': result['name'] ?? 'Not found',
      'phone': result['phone'] ?? 'Not found',
    };
  }
}
