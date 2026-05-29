import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/core/utils/shared_widgets/ride_destination_widget.dart';

class RidesListItem extends StatelessWidget {
  const RidesListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppConstant.shadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Canceled',
                style: Styles.textStyle16SemiBold(context),
              ),
              Text(
                '50.00 EGP',
                style: Styles.textStyle18Bold(context),
              ),
            ],
          ),
          8.ph,
          RideDestinationWidget(
            from: 'Shebeen El-kom',
            to: 'Shebeen El-kom',
          ),
          10.ph,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.r)),
            child: Text(
              'canceled',
              style: Styles.textStyle16SemiBold(context),
            ),
          ),
          10.ph,
        ],
      ),
    );
  }
}


