abstract class SpeechEvent {}

class StartListening extends SpeechEvent {}

class StopListening extends SpeechEvent {}

class SpeechRecognized extends SpeechEvent {
  final String recognizedText;
  SpeechRecognized(this.recognizedText);
}

