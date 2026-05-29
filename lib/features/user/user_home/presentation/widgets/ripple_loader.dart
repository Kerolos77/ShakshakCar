import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';

class RippleLoader extends StatelessWidget {
  const RippleLoader({
    super.key,
    required this.animation,
    this.size = 200,
    this.rings = 3,
  });

  final Animation<double> animation; // 0..1 repeating
  final double size;
  final int rings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          return CustomPaint(
            painter: RipplePainter(
              progress: animation.value, // ✅ 0..1 للأمام
              rings: rings,
            ),
          );
        },
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  RipplePainter({
    required this.progress,
    required this.rings,
  });

  final double progress; // 0..1
  final int rings;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 4);
    final maxRadius = size.width / 2;

    for (int i = 0; i < rings; i++) {
      final ringShift = i / rings; // 0.. <1
      double p = progress + ringShift;
      p = p - p.floorToDouble(); // keep in [0..1)

      final radius = maxRadius * p;

      // كل ما الحلقة تكبر: تخف وتختفي عند الأطراف
      final opacity = (1 - p).clamp(0.0, 1.0);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7 * (1 - p) + 1.5
        ..color = AppColors.primaryLightColor.withOpacity(opacity);

      canvas.drawCircle(center, radius, paint);
    }

    final corePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primaryColor;

    canvas.drawCircle(center, maxRadius * 0.10, corePaint);
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.rings != rings;
  }
}
