import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import '../../../../../core/utils/styles.dart';
import '../../../../../generated/l10n.dart';

class WaitingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40.r,
                    height: 40.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Styles.getPrimaryColor(context),
                    ),
                  ),
                  16.ph,
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      S.of(context).waitingForReplies,
                      style: Styles.textStyle16Bold(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
