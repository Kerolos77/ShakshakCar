import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/generated/assets.dart';

import 'package:shakshak/core/utils/styles.dart';

class OnBoardingPageItem extends StatelessWidget {
  const OnBoardingPageItem({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    List<String> onBoardingImages = [
      Assets.svgLogin,
      Assets.svgLogin,
      Assets.svgLogin,
    ];
    List<String> onBoardingTexts = [
      'text text 1',
      'text text 2',
      'text text 3',
    ];
    List<String> onBoardingTexts2 = [
      '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
      '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
      '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*   SizedBox(
          height: 315.h,
          child: SvgPicture.asset(onBoardingImages[index]),
        ), */
        SvgPicture.asset(
          onBoardingImages[index],
          width: MediaQuery.sizeOf(context).width * 0.8,
        ),
        45.ph,
        Column(
          children: [
            Text(
              onBoardingTexts[index],
              textAlign: TextAlign.center,
              style: Styles.textStyle20Bold(context),
            ),
            4.ph,
            Text(
              onBoardingTexts2[index],
              textAlign: TextAlign.center,
              style: Styles.textStyle14Medium(context),
            ),
          ],
        ).paddingSymmetric(horizontal: 40.w),
      ],
    ).paddingSymmetric(horizontal: 16.w);
  }
}


