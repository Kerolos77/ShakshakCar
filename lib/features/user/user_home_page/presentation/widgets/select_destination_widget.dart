import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/generated/l10n.dart';
import 'from_widget.dart';
import 'title_with_close_button.dart';

class SelectDestinationWidget extends StatelessWidget {
  const SelectDestinationWidget({
    super.key,
    required this.controller,
    required this.address,
    required this.changeMapTap,
  });

  final TextEditingController controller;
  final String address;
  final Function()? changeMapTap;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.93;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 22.0.w, right: 22.0.w),
            child: Column(
              children: [
                TitleWithCloseButton(title: S.of(context).chooseDestination),
                SizedBox(height: 20.h),
                FromWidget(address: address),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 45.h,
                  child: TextFormField(
                    style: TextStyle(fontSize: 14.sp),
                    keyboardType: TextInputType.streetAddress,
                    controller: controller,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.primaryLightColor,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0.h, horizontal: 10.0.w),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      hintText: S.of(context).to,
                      hintStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: changeMapTap,
                  child: Row(
                    children: [
                      Icon(Icons.add_location_alt,
                          color: AppColors.primaryColor),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          S.of(context).chooseOnMap,
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 18.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      buttonColor: AppColors.primaryColor,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      text: S.of(context).confirmDestination,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
