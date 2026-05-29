import 'package:flutter/material.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_icon_help.dart';

class InfoAndCancelWidget extends StatelessWidget {
  const InfoAndCancelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            radius: 17,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 17,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // لإغلاق BottomSheet
              },
            )),
        CustomIconHelp(
            title: "How to Use",
            content:
                "choose location from map \n and click srart for first location \n or end for last locatio \n or type your address"),
      ],
    );
  }
}
