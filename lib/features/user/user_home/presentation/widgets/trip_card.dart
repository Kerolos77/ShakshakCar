import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/generated/l10n.dart';

import 'animated_searching_text.dart';

class TripCard extends StatefulWidget {
  const TripCard({
    super.key,
    required this.newRideData,
  });

  final NewRideDataEntity newRideData;

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  bool isExpanded = false;
  late Timer _tipsTimer;
  int _currentTipIndex = 0;

  final List<String> _safetyTips = [
    "تأكد دائماً من رقم لوحة السيارة قبل الركوب.",
    "يمكنك مشاركة مسار رحلتك مع أصدقائك للأمان.",
    "جميع السائقين لدينا مسجلون ومعتمدون.",
    "قيم السائق بعد الرحلة لمساعدتنا في تحسين الخدمة.",
    "خدمة العملاء متوفرة على مدار الساعة للمساعدة.",
  ];

  @override
  void initState() {
    super.initState();
    // _tipsTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
    //   if (mounted) {
    //     setState(() {
    //       _currentTipIndex = (_currentTipIndex + 1) % _safetyTips.length;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _tipsTimer.cancel();
    super.dispose();
  }

  String _getPlaceName(String address) {
    if (address.isEmpty) return "...";
    // Try to get the first part before a comma
    final parts = address.split(',');
    if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
      return parts[0].trim();
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserHomeCubit, UserHomeState>(
      listener: (context, state) {
        if (state is CancelOrderSuccess) {
          navigateAndFinish(context, Routes.userHomeView);
        } else if (state is CancelOrderFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: AnimatedSearchingText()),
                16.pw,
                Text(
                  '${widget.newRideData.amount} ${S.of(context).currency}',
                  style: Styles.textStyle18Bold(context),
                ),
              ],
            ),
            8.ph,

            InkWell(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isExpanded ? S.of(context).hideDetails : S.of(context).showDetails,
                        style: Styles.textStyle14SemiBold(context).copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primaryColor,
                        size: 20.r,
                      ),
                    ],
                  ),
                  8.pw,
                  Expanded(
                    child: !isExpanded
                        ? Text(
                            "${_getPlaceName(widget.newRideData.sourceAddress)} ➔ ${_getPlaceName(widget.newRideData.destinationAddress)}",
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle12SemiBold(context).copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 20.r,
                            width: 20.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  width: 2),
                            ),
                          ),
                          8.pw,
                          Expanded(
                            child: Text(
                              widget.newRideData.sourceAddress,
                              style: Styles.textStyle14Medium(context),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: 15.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          child: const VerticalDivider()),
                      Row(
                        children: [
                          Container(
                            height: 20.r,
                            width: 20.r,
                            padding: EdgeInsets.all(1.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.onSurface,
                              border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 2),
                            ),
                            child: Icon(Icons.place,
                                color: Theme.of(context).colorScheme.surface,
                                size: 12.r),
                          ),
                          8.pw,
                          Expanded(
                            child: Text(
                              widget.newRideData.destinationAddress,
                              style: Styles.textStyle14Medium(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ),

            12.ph,
            // FadeIn(
            //   duration: const Duration(seconds: 1),
            //   child: Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.all(10.r),
            //     decoration: BoxDecoration(
            //       color: Theme.of(context)
            //           .colorScheme
            //           .surfaceContainerHighest
            //           .withOpacity(0.5),
            //       borderRadius: BorderRadius.circular(12.r),
            //       border: Border.all(
            //         color: AppColors.primaryColor.withOpacity(0.2),
            //       ),
            //     ),
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(Icons.lightbulb_outline,
            //                 color: AppColors.primaryColor, size: 16.sp),
            //             SizedBox(width: 8.w),
            //             Text(
            //               "هل تعلم؟",
            //               style: Styles.textStyle12Bold(context).copyWith(
            //                 color: AppColors.primaryColor,
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(height: 4.h),
            //         Text(
            //           _safetyTips[_currentTipIndex],
            //           textAlign: TextAlign.center,
            //           style: Styles.textStyle10SemiBold(context).copyWith(
            //             color: Theme.of(context).colorScheme.onSurface,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // 8.ph,
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).autoAccept,
                  style: Styles.textStyle14SemiBold(context),
                ),
                BlocBuilder<UserHomeCubit, UserHomeState>(
                  builder: (context, state) {
                    return Switch(
                      value: context.read<UserHomeCubit>().isAutoAcceptEnabled,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        context.read<UserHomeCubit>().toggleAutoAccept(value);
                      },
                    );
                  },
                ),
              ],
            ),
            10.ph,
            CustomButton(
              text: S.of(context).cancel,
              height: 38.h,
              borderRadius: 8,
              onTap: () {
                context.read<UserHomeCubit>().cancelOrder(
                      orderId: widget.newRideData.id,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
