import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

class CustomCancelDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String? title;
  final String? message;
  final String? warning;

  const CustomCancelDialog({
    super.key,
    required this.onConfirm,
    this.title,
    this.message,
    this.warning,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon Area
              Container(
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: Colors.redAccent,
                      size: 45.r,
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    Text(
                      title ?? S.of(context).confirm,
                      style: Styles.textStyle20Bold(context),
                      textAlign: TextAlign.center,
                    ),
                    12.ph,
                    Text(
                      message ?? S.of(context).cancelConfirmation,
                      style: Styles.textStyle16SemiBold(context).copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (warning != null || S.of(context).cancelWarning.isNotEmpty) ...[
                      16.ph,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange, size: 18.r),
                            8.pw,
                            Expanded(
                              child: Text(
                                warning ?? S.of(context).cancelWarning,
                                style: Styles.textStyle12SemiBold(context).copyWith(
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    24.ph,
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                side: BorderSide(color: Theme.of(context).dividerColor),
                              ),
                            ),
                            child: Text(
                              S.of(context).no, // Or "Keep Trip"
                              style: Styles.textStyle16Bold(context),
                            ),
                          ),
                        ),
                        16.pw,
                        Expanded(
                          child: CustomButton(
                            text: S.of(context).confirm,
                            buttonColor: Colors.redAccent,
                            textColor: Colors.white,
                            height: 50.h,
                            borderRadius: 14.r,
                            onTap: () {
                              Navigator.pop(context);
                              onConfirm();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Global helper to show the dialog
void showCustomCancelDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  String? title,
  String? message,
  String? warning,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return CustomCancelDialog(
        onConfirm: onConfirm,
        title: title,
        message: message,
        warning: warning,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      );
    },
  );
}
