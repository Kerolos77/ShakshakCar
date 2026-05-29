import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/generated/l10n.dart';

class NoTripsWidget extends StatefulWidget {
  const NoTripsWidget({Key? key}) : super(key: key);

  @override
  State<NoTripsWidget> createState() => _NoTripsWidgetState();
}

class _NoTripsWidgetState extends State<NoTripsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildCircle({
    required double baseSize,
    required double opacity,
    required Color color,
    required double scale,
    Widget? widget,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: baseSize.r * scale,
        height: baseSize.r * scale,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (_, __) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Largest outer circle
                  buildCircle(
                    baseSize: 250,
                    opacity: 0.2,
                    color: AppColors.primaryColor,
                    scale: _scaleAnimation.value,
                  ),

                  // Middle circle
                  buildCircle(
                    baseSize: 175,
                    opacity: 0.4,
                    color: AppColors.primaryColor,
                    scale: _scaleAnimation.value,
                  ),

                  // Small inner static circle
                  buildCircle(
                    baseSize: 100,
                    opacity: 1.0,
                    color: AppColors.primaryColor,
                    scale: 1.0,
                    widget: Icon(
                      Icons.person_pin,
                      color: Colors.white,
                      size: 50.r,
                    ),
                  ),
                ],
              ),
              16.ph,
              // PULSING TEXT
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Text(
                  S.of(context).noTripsNow,
                  style: Styles.textStyle22Bold(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

