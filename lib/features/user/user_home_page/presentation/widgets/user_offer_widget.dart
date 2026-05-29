import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

import 'find_driver_button.dart';
import 'title_with_close_button.dart';

class UserOfferWidget extends StatelessWidget {
  const UserOfferWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: Styles.textStyle18SemiBold(context),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 10.0.w),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
          hintText: S.of(context).offerYourFare,
          prefixText: S.of(context).egpPrefix,
          prefixStyle: Styles.textStyle18SemiBold(context).copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: const Icon(
            Icons.edit_outlined,
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              side: const BorderSide(),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(27.r),
                topLeft: Radius.circular(27.r),
              ),
            ),
            useSafeArea: true,
            isScrollControlled: true,
            // This ensures the modal adjusts to the keyboard.
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  // This adjusts the padding based on the height of the keyboard.
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(27.r),
                      topRight: Radius.circular(27.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(22.0.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // This will shrink the column size when keyboard opens.
                        children: [
                          TitleWithCloseButton(
                            title: S.of(context).offerYourFare,
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: TextFormField(
                              controller: controller,
                              style: Styles.textStyle28Bold(context).copyWith(
                                fontSize: 40.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: S.of(context).egpPrefix,
                                hintStyle:
                                    Styles.textStyle28Bold(context).copyWith(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Theme.of(context).hintColor,
                                  size: 30.sp,
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Text(
                                    S.of(context).promoCode,
                                    style: Styles.textStyle18SemiBold(context)
                                        .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Icon(
                                Icons.money_outlined,
                                color: Colors.green,
                                size: 30.sp,
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: Text(
                                  S.of(context).cash,
                                  style: Styles.textStyle18SemiBold(context)
                                      .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: DriverButton(
                              buttonText: S.of(context).done,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
