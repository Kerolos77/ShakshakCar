import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';

class ConfirmTripButtonWidget extends StatelessWidget {
  const ConfirmTripButtonWidget({super.key, required this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      buttonColor: AppColors.primaryColor,
      height: 55.h,
      borderRadius: 18.r,
      onTap: onPressed,
      text: S.of(context).confirmTrip,
    );
  }
}
