abstract class SpeechEvent {}

class StartListeningEvent extends SpeechEvent {}
class StopListeningEvent extends SpeechEvent {}
class ProcessSpeechEvent extends SpeechEvent {
  final String speechText;
  ProcessSpeechEvent(this.speechText);
}


// abstract class SpeechEvent {}

// class StartListening extends SpeechEvent {}

// class StopListening extends SpeechEvent {}

// class TranscriptionComplete extends SpeechEvent {
//   final String text;
//   TranscriptionComplete(this.text);
// }
