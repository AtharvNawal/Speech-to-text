import 'package:flutter_bloc/flutter_bloc.dart';
import 'speech_event.dart';
import 'speech_state.dart';
import 'speech_repository.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechRepository repo;

  SpeechBloc(this.repo) : super(SpeechInitial()) {
    on<StartListeningEvent>((_, emit) => emit(SpeechListening()));
    on<StopListeningEvent>((_, emit) => emit(SpeechInitial()));

    on<ProcessSpeechEvent>((event, emit) async {
      emit(SpeechProcessing());
      try {
        final translated = await repo.translateIfNeeded(event.speechText);
        final result = await repo.extractEntities(translated);
        emit(SpeechResult(name: result['name']!, phone: result['phone']!, text: event.speechText));
      } catch (e) {
        emit(SpeechError('Processing failed: $e'));
      }
    });
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'speech_event.dart';
// import 'speech_state.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'speech_repository.dart';

// class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
//   final SpeechRepository repository;
//   final SpeechToText voice = SpeechToText();

//   SpeechBloc(this.repository) : super(SpeechInitial()) {
//     on<StartListening>((event, emit) async {
//       if (await voice.initialize()) {
//         emit(SpeechListening());
//         voice.listen(onResult: (result) async {
//           if (result.finalResult) {
//             add(TranscriptionComplete(result.recognizedWords));
//           }
//         });
//       } else {
//         emit(SpeechError('Speech initialization failed.'));
//       }
//     });

//     on<StopListening>((event, emit) async {
//       await voice.stop();
//       emit(SpeechInitial());
//     });

//     on<TranscriptionComplete>((event, emit) async {
//       emit(SpeechLoading());
//       try {
//         final data = await repository.extractInfo(event.text);
//         emit(SpeechResult(event.text, data['name'], data['phone']));
//       } catch (e) {
//         emit(SpeechError('Extraction failed: $e'));
//       }
//     });
//   }
// }
