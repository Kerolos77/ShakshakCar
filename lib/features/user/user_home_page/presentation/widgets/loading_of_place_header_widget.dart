import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';

class LoadingOfPlaceHeaderWidget extends StatelessWidget {
  const LoadingOfPlaceHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.primaryColor,
      ),
      width: 48,
      height: 38,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.whiteColor),
          strokeWidth: 2.6,
        ),
      ),
    );
  }
}
