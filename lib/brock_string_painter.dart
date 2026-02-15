import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Direction modes for the Brock String.
enum MovementMode {
  horizontal,
  vertical,
  diagonalTLBR, // Top-Left → Bottom-Right
  diagonalTRBL, // Top-Right → Bottom-Left
  ellipse,
  circle,
  infinity, // Figure-8 / lemniscate
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

    final cx = size.width / 2;
    final cy = size.height / 2;
    final rx = (size.width - 80) / 2;
    final ry = (size.height - 80) / 2;

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

      case MovementMode.vertical:
        canvas.drawLine(
          Offset(cx, padding),
          Offset(cx, size.height - padding),
          paint,
        );
        final y = padding + beadPosition * (size.height - 80);
        beadOffset = Offset(cx, y);
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

      case MovementMode.ellipse:
        _drawEllipsePath(canvas, paint, cx, cy, rx, ry);
        beadOffset = _ellipsePoint(cx, cy, rx, ry, beadPosition);
        break;

      case MovementMode.circle:
        final r = math.min(rx, ry);
        _drawEllipsePath(canvas, paint, cx, cy, r, r);
        beadOffset = _ellipsePoint(cx, cy, r, r, beadPosition);
        break;

      case MovementMode.infinity:
        _drawInfinityPath(canvas, paint, cx, cy, rx, ry);
        beadOffset = _infinityPoint(cx, cy, rx, ry, beadPosition);
        break;
    }

    final beadPaint = Paint()
      ..color = _beadColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(beadOffset, 18, beadPaint);
  }

  void _drawEllipsePath(
    Canvas canvas,
    Paint paint,
    double cx,
    double cy,
    double rx,
    double ry,
  ) {
    final path = Path();
    const steps = 64;
    for (var i = 0; i <= steps; i++) {
      final t = (i / steps) * 2 * math.pi;
      final x = cx + rx * math.cos(t);
      final y = cy + ry * math.sin(t);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  Offset _ellipsePoint(double cx, double cy, double rx, double ry, double t) {
    final angle = t * 2 * math.pi;
    return Offset(
      cx + rx * math.cos(angle),
      cy + ry * math.sin(angle),
    );
  }

  void _drawInfinityPath(
    Canvas canvas,
    Paint paint,
    double cx,
    double cy,
    double rx,
    double ry,
  ) {
    final path = Path();
    const steps = 64;
    for (var i = 0; i <= steps; i++) {
      final t = (i / steps) * 2 * math.pi;
      final x = cx + rx * math.cos(t);
      final y = cy + ry * math.sin(2 * t) / 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  Offset _infinityPoint(double cx, double cy, double rx, double ry, double t) {
    final angle = t * 2 * math.pi;
    return Offset(
      cx + rx * math.cos(angle),
      cy + ry * math.sin(2 * angle) / 2,
    );
  }

  @override
  bool shouldRepaint(covariant BrockStringPainter oldDelegate) {
    return oldDelegate.beadPosition != beadPosition ||
        oldDelegate.mode != mode;
  }
}
