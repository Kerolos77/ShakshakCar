import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/core/utils/shared_widgets/custom_icon_help.dart';

class ChooseVehicleAndInfoWidget extends StatelessWidget {
  const ChooseVehicleAndInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Choose vehicle",
          style: TextStyle(fontSize: 18.sp),
        ),
        CustomIconHelp(
            title: "Details",
            content:
                "choose your vichcle \n you have more options \n if your trip more than \n 60 kilometer go to travel "),
      ],
    );
  }
}


