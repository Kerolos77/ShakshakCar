import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';

import 'package:shakshak/features/user/user_home_page/logic/home_cubit.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_states.dart';

class TravelTimeWidget extends StatefulWidget {
  const TravelTimeWidget({Key? key}) : super(key: key);

  @override
  _TravelTimeWidgetState createState() => _TravelTimeWidgetState();
}

class _TravelTimeWidgetState extends State<TravelTimeWidget> {
  dynamic time = 0; // To store the travel time

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLightColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.primaryColor,
              ),
              SizedBox(
                width: 10.w,
              ),
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is CalcPriceAndTimeDistanceSuccessState) {
                    setState(() {
                      time = "10"; // Capture the travel time from the state
                    });
                  }
                },
                builder: (context, state) {
                  return Text(
                    "Travel time: ~$time min",
                    style: TextStyle(
                        fontSize: 18.sp, color: AppColors.primaryColor),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
