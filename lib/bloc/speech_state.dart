abstract class SpeechState {}

class SpeechInitial extends SpeechState {}
class SpeechListening extends SpeechState {}
class SpeechProcessing extends SpeechState {}
class SpeechResult extends SpeechState {
  final String name;
  final String phone;
  final String text;
  SpeechResult({required this.name, required this.phone, required this.text});
}
class SpeechError extends SpeechState {
  final String message;
  SpeechError(this.message);
}

// abstract class SpeechState {}

// class SpeechInitial extends SpeechState {}

// class SpeechListening extends SpeechState {}

// class SpeechLoading extends SpeechState {}

// class SpeechResult extends SpeechState {
//   final String originalText;
//   final String name;
//   final String phone;
//   SpeechResult(this.originalText, this.name, this.phone);
// }

// class SpeechError extends SpeechState {
//   final String message;
//   SpeechError(this.message);
// }
