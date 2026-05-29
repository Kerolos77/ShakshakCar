import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';

class UseMapButtonWidget extends StatelessWidget {
  const UseMapButtonWidget({super.key, required this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 1,
      right: 1,
      child: CustomButton(
        buttonColor: AppColors.primaryColor,
        height: 50.h,
        borderRadius: 18.r,
        onTap: onPressed,
        text: S.of(context).useMap,
      ),
    );
  }
}
