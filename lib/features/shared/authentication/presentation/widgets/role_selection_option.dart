import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/core/utils/styles.dart';

class RoleSelectionOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final String text, details;
  final IconData icon;

  const RoleSelectionOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
    required this.details,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.15),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 16.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: Styles.textStyle18Bold(context),
                  ),
                  6.ph,
                  Text(
                    details,
                    style: Styles.textStyle14SemiBold(context),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              size: 33.r,
            )
          ],
        ),
      ),
    );
  }
}


