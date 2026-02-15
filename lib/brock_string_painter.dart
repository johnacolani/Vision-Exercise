import 'package:flutter/material.dart';

/// Direction modes for the Brock String.
enum MovementMode {
  horizontal,
  diagonalTLBR, // Top-Left → Bottom-Right
  diagonalTRBL, // Top-Right → Bottom-Left
}

/// Custom painter for the Brock String vision therapy exercise.
///
/// Draws a string with a moving bead. Uses beadPosition (0.1–0.9) for
/// movement along the string. Supports horizontal and diagonal modes.
class BrockStringPainter extends CustomPainter {
  BrockStringPainter({
    required this.beadPosition,
    this.mode = MovementMode.horizontal,
  });

  /// Bead position along the string: 0.1 = near start, 0.9 = near end.
  final double beadPosition;

  /// Movement direction of the string and bead.
  final MovementMode mode;

  static const Color _stringColor = Color(0xFF333333);
  static const Color _beadColor = Color(0xFF1565C0);

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 40.0;

    final paint = Paint()
      ..color = _stringColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset beadOffset;

    switch (mode) {
      case MovementMode.horizontal:
        final y = size.height / 2;
        canvas.drawLine(
          Offset(padding, y),
          Offset(size.width - padding, y),
          paint,
        );
        final x = padding + beadPosition * (size.width - 80);
        beadOffset = Offset(x, y);
        break;

      case MovementMode.diagonalTLBR:
        canvas.drawLine(
          const Offset(padding, padding),
          Offset(size.width - padding, size.height - padding),
          paint,
        );
        final x = padding + beadPosition * (size.width - 80);
        final y = padding + beadPosition * (size.height - 80);
        beadOffset = Offset(x, y);
        break;

      case MovementMode.diagonalTRBL:
        canvas.drawLine(
          Offset(size.width - padding, padding),
          Offset(padding, size.height - padding),
          paint,
        );
        final x = (size.width - padding) - beadPosition * (size.width - 80);
        final y = padding + beadPosition * (size.height - 80);
        beadOffset = Offset(x, y);
        break;
    }

    final beadPaint = Paint()
      ..color = _beadColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(beadOffset, 18, beadPaint);
  }

  @override
  bool shouldRepaint(covariant BrockStringPainter oldDelegate) {
    return oldDelegate.beadPosition != beadPosition ||
        oldDelegate.mode != mode;
  }
}
