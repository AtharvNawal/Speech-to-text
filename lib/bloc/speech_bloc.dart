import 'package:flutter_bloc/flutter_bloc.dart';
import 'speech_event.dart';
import 'speech_state.dart';
import 'speech_repository.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechRepository repository;

  SpeechBloc(this.repository) : super(InitialState()) {
    on<StartListening>((event, emit) async {
      emit(ListeningState());
      repository.startListening((text) {
        add(SpeechRecognized(text));
      });
    });

    on<StopListening>((event, emit) async {
      await repository.stopListening();
      emit(InitialState());
    });

    on<SpeechRecognized>((event, emit) async {
      emit(ProcessingState(event.recognizedText));
      try {
        final result = await repository.processSpeech(event.recognizedText);
        emit(ResultState(result['name'] ?? 'Not found', result['phone'] ?? 'Not found', event.recognizedText));
      } catch (e) {
        emit(ErrorState("Failed to extract details."));
      }
    });
  }
}
