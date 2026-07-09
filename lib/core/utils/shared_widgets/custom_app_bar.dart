import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/styles.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool forceDrawer;
  final Widget? trailing;

  const CustomAppBar({
    super.key,
    required this.title,
    this.forceDrawer = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          !forceDrawer && canPop()
              ? IconButton(
                  onPressed: () {
                    navigatePop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 24.r,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 30.r,
                  ),
                ),
          Expanded(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: Styles.textStyle20Bold(context).copyWith(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 22.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing ?? SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
