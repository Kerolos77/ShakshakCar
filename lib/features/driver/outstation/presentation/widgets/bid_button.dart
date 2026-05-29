import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/styles.dart';

class BidButton extends StatelessWidget {
  const BidButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.disabled,
  });

  final String label;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: SizedBox(
        width: 45.w,
        height: 40.h,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: disabled ? null : onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Styles.getPrimaryColor(context).withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  label,
                  style: Styles.textStyle14Bold(context).copyWith(
                    color: Styles.getPrimaryColor(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
