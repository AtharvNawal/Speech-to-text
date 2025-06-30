import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../bloc/speech_bloc.dart';
import '../bloc/speech_event.dart';
import '../bloc/speech_state.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});
  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final voice = SpeechToText();

  @override
  void initState() {
    super.initState();
    voice.initialize();
  }

  void _listen(SpeechBloc bloc) async {
    if (voice.isListening) {
      await voice.stop();
      bloc.add(StopListeningEvent());
    } else {
      bloc.add(StartListeningEvent());
      voice.listen(
        localeId: 'en_US',
        onResult: (result) {
          if (result.finalResult) {
            bloc.add(ProcessSpeechEvent(result.recognizedWords));
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech → Name & Phone Extractor')),
      body: BlocBuilder<SpeechBloc, SpeechState>(
        builder: (context, state) {
          String displayText = '';
          String name = '', phone = '';
          bool loading = false;

          if (state is SpeechResult) {
            displayText = state.text;
            name = state.name;
            phone = state.phone;
          } else if (state is SpeechProcessing) {
            loading = true;
          } else if (state is SpeechError) {
            displayText = state.message;
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayText.isEmpty ? 'Tap the mic and speak...' : displayText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                if (loading) const CircularProgressIndicator(),
                if (!loading && name.isNotEmpty) ...[
                  Text('👤 Name: $name', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('📞 Phone: $phone', style: const TextStyle(fontSize: 18)),
                ],
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: Icon(voice.isListening ? Icons.mic_off : Icons.mic),
                  label: Text(voice.isListening ? 'Stop' : 'Start Listening'),
                  onPressed: () => _listen(context.read<SpeechBloc>()),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/speech_bloc.dart';
// import '../bloc/speech_event.dart';
// import '../bloc/speech_state.dart';

// class SpeechScreen extends StatelessWidget {
//   const SpeechScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SpeechBloc, SpeechState>(
//       builder: (context, state) {
//         String displayedText = 'Tap the mic and start speaking...';
//         String name = '';
//         String phone = '';
//         bool isListening = false;

//         if (state is SpeechListening) {
//           isListening = true;
//         } else if (state is SpeechResult) {
//           displayedText = state.originalText;
//           name = state.name;
//           phone = state.phone;
//         } else if (state is SpeechError) {
//           displayedText = state.message;
//         } else if (state is SpeechInitial) {
//           isListening = false;
//         }

//         return Scaffold(
//           appBar: AppBar(title: const Text('Multilingual Speech Extractor')),
//           body: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(displayedText, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
//                 const SizedBox(height: 20),
//                 if (state is SpeechLoading)
//                   const CircularProgressIndicator(),
//                 if (state is SpeechResult) ...[
//                   Text('Name: $name', style: const TextStyle(fontSize: 18)),
//                   const SizedBox(height: 10),
//                   Text('Phone: $phone', style: const TextStyle(fontSize: 18)),
//                 ],
//                 const SizedBox(height: 30),
//                 ElevatedButton.icon(
//                   icon: Icon(isListening ? Icons.mic_off : Icons.mic),
//                   label: Text(isListening ? 'Stop' : 'Start Listening'),
//                   onPressed: () {
//                     final bloc = context.read<SpeechBloc>();
//                     if (isListening) {
//                       bloc.add(StopListening());
//                     } else {
//                       bloc.add(StartListening());
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
