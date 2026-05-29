import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/styles.dart';

class CustomDrawerItem extends StatelessWidget {
  const CustomDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  final String title;
  final IconData icon;
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
            border: isSelected 
                ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                size: 22.r,
              ),
              16.pw,
              Expanded(
                child: Text(
                  title,
                  style: Styles.textStyle16SemiBold(context).copyWith(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 15.sp,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

extension Spacing on num {
  Widget get pw => SizedBox(width: toDouble().w);
}
