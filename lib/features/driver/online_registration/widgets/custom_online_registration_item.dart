import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/core/utils/styles.dart';

class CustomOnlineRegistrationItem extends StatelessWidget {
  const CustomOnlineRegistrationItem({
    super.key,
    required this.title,
    this.onTap,
    this.isCompleted = false,
    this.icon,
  });

  final String title;
  final void Function()? onTap;
  final bool isCompleted;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isCompleted
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : Theme.of(context).dividerColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Theme.of(context).dividerColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.description_outlined,
                color: isCompleted
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor,
                size: 24.r,
              ),
            ),
            16.pw,
            Expanded(
              child: Text(
                title,
                style: Styles.textStyle16SemiBold(context).copyWith(
                  color: isCompleted ? null : Theme.of(context).hintColor,
                ),
              ),
            ),
            if (isCompleted)
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).primaryColor,
                size: 24.r,
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).hintColor.withOpacity(0.5),
                size: 16.r,
              ),
          ],
        ),
      ),
    );
  }
}

extension Spacing on num {
  Widget get pw => SizedBox(width: toDouble().w);
}
