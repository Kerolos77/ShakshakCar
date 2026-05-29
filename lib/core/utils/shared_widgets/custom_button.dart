import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.buttonColor,
    this.textColor = AppColors.whiteColor,
    this.hPadding = 0,
    this.borderRadius = 16,
    this.borderColor = AppColors.transparent,
    this.width = double.infinity,
    this.height = 56,
    this.vPadding = 0,
    this.img,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
    this.isLoading = false,
  });

  final String text;
  final Widget? img;
  final VoidCallback? onTap;
  final Color? textColor;
  final double hPadding, width, height, vPadding;
  final double borderRadius;
  final Color borderColor;
  final Color? buttonColor;
  final double fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
            color: buttonColor ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(borderRadius.r),
            boxShadow: AppConstant.shadow,
            border: Border.all(
              color: borderColor,
            )),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 24.h,
                  width: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: Styles.textStyle16Bold(context).copyWith(
                          fontSize: fontSize.sp,
                          fontWeight: fontWeight,
                          color: textColor),
                    ),
                    if (img != null) ...[
                      6.pw,
                      img!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
