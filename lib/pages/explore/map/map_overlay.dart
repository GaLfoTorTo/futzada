import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class MapOverlay extends CustomPainter {
  final Offset center;
  final double radius;

  MapOverlay({required this.center, required this.radius});

   @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = AppColors.white.withAlpha(150)
      ..style = PaintingStyle.fill;

    final blurPaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 20);

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, overlayPaint);
    canvas.drawCircle(center, radius, blurPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
