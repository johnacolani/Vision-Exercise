import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:vision_exercise/brock_string_painter.dart';

void main() {
  group('BrockStringPainter', () {
    BrockStringPainter createPainter({double beadPosition = 0.5}) {
      return BrockStringPainter(beadPosition: beadPosition);
    }

    test('shouldRepaint returns true when beadPosition changes', () {
      final oldDelegate = createPainter(beadPosition: 0.3);
      final newDelegate = createPainter(beadPosition: 0.5);

      expect(newDelegate.shouldRepaint(oldDelegate), isTrue);
    });

    test('shouldRepaint returns false when nothing changes', () {
      final delegate = createPainter(beadPosition: 0.5);
      final sameDelegate = createPainter(beadPosition: 0.5);

      expect(sameDelegate.shouldRepaint(delegate), isFalse);
    });

    test('shouldRepaint returns true when mode changes', () {
      final oldDelegate = BrockStringPainter(
        beadPosition: 0.5,
        mode: MovementMode.horizontal,
      );
      final newDelegate = BrockStringPainter(
        beadPosition: 0.5,
        mode: MovementMode.diagonalTLBR,
      );

      expect(newDelegate.shouldRepaint(oldDelegate), isTrue);
    });

    test('paint does not throw', () {
      final painter = createPainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      expect(
        () => painter.paint(canvas, const Size(800, 400)),
        returnsNormally,
      );
    });
  });
}
