import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';

class DriverButton extends StatelessWidget {
  DriverButton(
      {super.key,
      this.onPressed,
      this.buttonColor,
      this.textColor,
      required this.buttonText});

  final Function()? onPressed;
  final String buttonText;
  Color? textColor;
  Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            // horizontal: 30.w,
            vertical: 15.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.r,
            ),
          ),
          backgroundColor: buttonColor ?? AppColors.primaryColor,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}


