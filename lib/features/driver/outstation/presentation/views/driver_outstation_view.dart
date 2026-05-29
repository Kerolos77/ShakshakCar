import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/rides/presentation/widgets/rides_list.dart';

class DriverOutstationView extends StatelessWidget {
  const DriverOutstationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).outstation,
      horizontalPadding: 0,
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: AppConstant.shadow,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.darkGreyColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        dividerColor: Colors.transparent,
                        labelStyle: Styles.textStyle16Bold(context).copyWith(
                          fontFamily: 'Cairo',
                        ),
                        unselectedLabelStyle:
                            Styles.textStyle16Bold(context).copyWith(
                          fontFamily: 'Cairo',
                        ),
                        tabs: [
                          /*  Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('New'),
                                6.pw,
                                Icon(Icons.list),
                              ],
                            ),
                          ),*/
                          Tab(text: S.of(context).newRide),
                          Tab(text: S.of(context).active),
                          Tab(text: S.of(context).completed),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  RidesList(
                    isOutstation: true,
                    rides: [],
                  ),
                  RidesList(
                    isOutstation: true,
                    rides: [],
                  ),
                  RidesList(
                    isOutstation: true,
                    rides: [],
                  ),
                ],
              )),
            ],
          )),
    );
  }
}



