import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';

class RideDestinationWidget extends StatelessWidget {
  const RideDestinationWidget({
    super.key,
    required this.from,
    required this.to,
  });

  final String from, to;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              height: 24.r,
              width: 24.r,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 30.h, child: VerticalDivider()),
            Container(
              height: 24.r,
              width: 24.r,
              padding: EdgeInsets.all(1.r),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.place,
                color: Theme.of(context).cardColor,
                size: 16.r,
              ),
            ),
          ],
        ),
        12.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                from,
                style: Styles.textStyle16Medium(context),
              ),
              30.ph,
              Text(
                to,
                style: Styles.textStyle16SemiBold(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
