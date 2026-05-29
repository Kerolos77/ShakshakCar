import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

class WaitingForDriversWidget extends StatefulWidget {
  const WaitingForDriversWidget({super.key});

  @override
  State<WaitingForDriversWidget> createState() =>
      _WaitingForDriversWidgetState();
}

class _WaitingForDriversWidgetState extends State<WaitingForDriversWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 20.h,
        bottom: 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Searching Animation (Simplified)
          SizedBox(height: 60.h),
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: const SpinKitDoubleBounce(
              color: AppColors.primaryColor,
              size: 90,
            ),
          ),

          40.ph,

          // 2. Status Text
          Text(
            S.of(context).connectingWithDrivers,
            style: Styles.textStyle18Bold(context),
            textAlign: TextAlign.center,
          ),

          12.ph,

          Text(
            S.of(context).offersWillAppearHere,
            style: Styles.textStyle14SemiBold(context).copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          20.ph,
        ],
      ),
    );
  }
}
