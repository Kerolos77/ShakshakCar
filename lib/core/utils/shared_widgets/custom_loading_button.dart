import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/resources/app_colors.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton(
      {super.key,
      this.color = AppColors.secondaryColor,
      this.circleIndicatorColor = AppColors.secondaryColor,
      this.height = 56,
      this.borderRadius = 16});

  final Color color;
  final Color circleIndicatorColor;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        boxShadow: AppConstant.shadow,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
