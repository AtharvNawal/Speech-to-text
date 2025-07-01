import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/speech_bloc.dart';
import '../bloc/speech_event.dart';
import '../bloc/speech_state.dart';
import '../bloc/speech_repository.dart';

class SpeechScreen extends StatelessWidget {
  const SpeechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpeechBloc(SpeechRepository()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Speech → Name & Phone Extractor')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<SpeechBloc, SpeechState>(
            builder: (context, state) {
              final bloc = context.read<SpeechBloc>();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state is ProcessingState || state is ResultState
                        ? (state is ProcessingState
                            ? state.spokenText
                            : (state as ResultState).originalText)
                        : 'Tap the mic and speak...',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (state is ProcessingState) const CircularProgressIndicator(),
                  if (state is ResultState) ...[
                    Text('👤 Name: ${state.name}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('📞 Phone: ${state.phone}', style: const TextStyle(fontSize: 18)),
                  ],
                  if (state is ErrorState) Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: Icon(state is ListeningState ? Icons.mic_off : Icons.mic),
                    label: Text(state is ListeningState ? 'Stop' : 'Start Listening'),
                    onPressed: () {
                      if (state is ListeningState) {
                        bloc.add(StopListening());
                      } else {
                        bloc.add(StartListening());
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
