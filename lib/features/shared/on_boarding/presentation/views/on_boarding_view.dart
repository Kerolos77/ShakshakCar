import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/generated/assets.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/on_boarding/presentation/widgets/on_boarding_page.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({
    super.key,
  });

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  List<String> onBoardingImages = [
    Assets.svgOnboarding1,
    Assets.svgOnboarding2,
    Assets.svgOnboarding3,
  ];
  PageController controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                Assets.svgShape1,
                width: MediaQuery.sizeOf(context).width,
              ),
              Positioned(
                bottom: -100,
                child: Container(
                  width: 250.r,
                  height: 250.r,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 200.r,
                  ),
                ),
              )
            ],
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 30.h,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: index == 0
                      ? SizedBox(
                          height: 46.h,
                          width: 35.w,
                        )
                      : IconButton(
                          onPressed: () {
                            controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.primaryColor,
                            size: 20.r,
                          )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 30.h,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: index == onBoardingImages.length - 1
                      ? SizedBox(
                          height: 40.h,
                          width: 35.w,
                        )
                      : TextButton(
                          onPressed: () async {
                            await CacheHelper.saveData(
                                key: AppConstant.kOnBoarding, value: true);
                            if (!mounted) return;
                            navigateAndFinish(context, Routes.loginView);
                          },
                          child: Text(
                            S.of(context).skip,
                            style: Styles.textStyle14SemiBold(context),
                          ),
                        ),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              onPageChanged: (value) {
                index = value;
                setState(() {});
              },
              itemCount: onBoardingImages.length,
              controller: controller,
              itemBuilder: (context, index) {
                return OnBoardingPageItem(
                  index: index,
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: onBoardingImages.length,
            effect: WormEffect(
              spacing: 18.w,
              dotColor: AppColors.primaryColor,
              paintStyle: PaintingStyle.stroke,
              activeDotColor: AppColors.primaryColor,
              dotHeight: 12.r,
              dotWidth: 12.r,
            ),
          ),
          40.ph,
          CustomButton(
            onTap: () async {
              if (index == onBoardingImages.length - 1) {
                await CacheHelper.saveData(
                    key: AppConstant.kOnBoarding, value: true);
                if (!mounted) return;
                navigateAndFinish(context, Routes.loginView);
              } else {
                controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }
            },
            text: index == onBoardingImages.length - 1
                ? S.of(context).enrollNow
                : S.of(context).next,
          ).paddingSymmetric(horizontal: 16.w),
          20.ph,
        ],
      ),
    );
  }
}


