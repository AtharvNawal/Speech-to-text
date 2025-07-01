abstract class SpeechState {}

class InitialState extends SpeechState {}

class ListeningState extends SpeechState {}

class ProcessingState extends SpeechState {
  final String spokenText;
  ProcessingState(this.spokenText);
}

class ResultState extends SpeechState {
  final String name;
  final String phone;
  final String originalText;
  ResultState(this.name, this.phone, this.originalText);
}

class ErrorState extends SpeechState {
  final String message;
  ErrorState(this.message);
}
