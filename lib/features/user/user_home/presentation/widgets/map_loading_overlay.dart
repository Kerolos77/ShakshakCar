import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ripple_loader.dart';

class MapLoadingOverlay extends StatelessWidget {
  const MapLoadingOverlay({super.key, required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          // Scrim خفيف فوق الخريطة
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.18),
            ),
          ),

          // ✅ Ripple Loader (موجة دائرية كبيرة)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RippleLoader(
                  animation: controller,
                  size: 300.w,
                  rings: 4,
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
