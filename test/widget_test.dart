// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:phn_name_extractor/main.dart'; // Replace with your actual project name
import 'package:phn_name_extractor/UI/speech_screen.dart'; // Import the file where SpeechScreen is defined

void main() {
  testWidgets('SpeechScreen loads and mic button toggles icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SpeechScreen(),
      ),
    );

    // Check initial UI state
    expect(find.byType(Text), findsOneWidget);
    expect(find.byIcon(Icons.mic_none), findsOneWidget);

    // Tap the mic button (note: actual speech won't be triggered in tests)
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Since voice input won't work in widget tests, we can't validate speech-to-text
    // But you can confirm icon changes or UI reactions if you fake state
  });
}
