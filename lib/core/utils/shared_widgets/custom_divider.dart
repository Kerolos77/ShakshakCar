import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/core/resources/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.height = 20,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height.h,
      color: AppColors.lightGreyColor,
    );
  }
}
