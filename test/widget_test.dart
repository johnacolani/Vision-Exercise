import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vision_exercise/main.dart';
import 'package:vision_exercise/exercise_screen.dart';
import 'package:vision_exercise/splash_screen.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('shows rotate device message after one bounce cycle',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: const SplashScreen()),
      );
      expect(
        find.textContaining('Please rotate your device to landscape'),
        findsNothing,
      );
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump();

      expect(
        find.textContaining('Please rotate your device to landscape'),
        findsOneWidget,
      );
      expect(find.textContaining('Tap to continue'), findsOneWidget);
    });

    testWidgets('navigates to exercise screen when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: const SplashScreen()),
      );
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump();

      await tester.tap(find.textContaining('Please rotate your device'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Brock String Exercise'), findsOneWidget);
    });
  });

  group('VisionExerciseApp', () {
    Future<void> tapThroughSplash(WidgetTester tester) async {
      await tester.pumpWidget(const VisionExerciseApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump();
      await tester.tap(find.textContaining('Please rotate your device'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('renders Brock String Exercise screen after splash',
        (WidgetTester tester) async {
      await tapThroughSplash(tester);

      expect(find.text('Brock String Exercise'), findsOneWidget);
      expect(
        find.text('Focus on the moving bead. Keep both eyes aligned.'),
        findsOneWidget,
      );
    });

    testWidgets('has Start/Pause floating action button',
        (WidgetTester tester) async {
      await tapThroughSplash(tester);

      // Initially running: shows Pause
      expect(find.text('Pause'), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('Start button appears when Pause is tapped',
        (WidgetTester tester) async {
      await tapThroughSplash(tester);

      expect(find.text('Pause'), findsOneWidget);

      await tester.tap(find.text('Pause'));
      await tester.pump();

      expect(find.text('Start'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('Pause button appears again when Start is tapped',
        (WidgetTester tester) async {
      await tapThroughSplash(tester);

      await tester.tap(find.text('Pause'));
      await tester.pump();

      await tester.tap(find.text('Start'));
      await tester.pump();

      expect(find.text('Pause'), findsOneWidget);
    });

    testWidgets('uses CustomPaint for Brock string visualization',
        (WidgetTester tester) async {
      await tapThroughSplash(tester);

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('BrockStringExerciseScreen', () {
    testWidgets('displays instruction text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const BrockStringExerciseScreen(),
        ),
      );

      expect(
        find.text('Focus on the moving bead. Keep both eyes aligned.'),
        findsOneWidget,
      );
    });

    testWidgets('has AppBar with correct title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const BrockStringExerciseScreen(),
        ),
      );

      expect(find.text('Brock String Exercise'), findsOneWidget);
    });
  });
}
