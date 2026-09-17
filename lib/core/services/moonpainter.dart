import 'dart:math' as math;

import 'package:flutter/material.dart';

class _MoonPhasePainter extends CustomPainter {
  final double phase; // 0.0 = new moon → 0.5 = full moon → 1.0 = new moon

  const _MoonPhasePainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);

    // Dark background
    canvas.drawCircle(center, r, Paint()..color = const Color(0xFF1A1A2E));

    final litPaint  = Paint()..color = const Color(0xFFEEDDAA);
    final darkPaint = Paint()..color = const Color(0xFF1A1A2E);

    // Draw lit half based on phase
    final deg = phase * 360;
    if (deg < 180) {
      // Waxing: right half lit
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -math.pi / 2, math.pi, false, litPaint,
      );
      // Overlay ellipse to shape waxing crescent→gibbous
      final scaleX = math.cos(deg * math.pi / 180);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2 * scaleX.abs(), height: r * 2),
        deg < 90 ? darkPaint : litPaint,
      );
    } else {
      // Waning: left half lit
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        math.pi / 2, math.pi, false, litPaint,
      );
      final scaleX = math.cos(deg * math.pi / 180);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2 * scaleX.abs(), height: r * 2),
        deg < 270 ? litPaint : darkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_MoonPhasePainter old) => old.phase != phase;
}