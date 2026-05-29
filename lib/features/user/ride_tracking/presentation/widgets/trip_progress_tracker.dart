import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:marquee/marquee.dart';

class TripProgressTracker extends StatelessWidget {
  final String status;
  final String? eta;

  const TripProgressTracker({super.key, required this.status, this.eta});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final currentStepIndex = _getCurrentStepIndex(status);
    const totalSteps = 5;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.95),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              bool isCompleted = index < currentStepIndex;
              bool isActive = index == currentStepIndex;
              
              return Expanded(
                child: Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2.h,
                          color: index <= currentStepIndex
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                        ),
                      ),
                    _buildStepIcon(index, isCompleted, isActive),
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2.h,
                          color: index < currentStepIndex
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          12.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_formattedEta != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _formattedEta!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                8.pw,
              ],
              Flexible(
                child: SizedBox(
                  height: 25.h,
                  child: Marquee(
                    text: _getDetailedStatusMessage(status, s),
                    style: Styles.textStyle14SemiBold(context).copyWith(
                      color: Colors.white,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 50.0,
                    velocity: 25.0,
                    pauseAfterRound: const Duration(seconds: 2),
                    startPadding: 10.0,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? get _formattedEta {
    if (eta == null || eta!.isEmpty) return null;
    try {
      final seconds = double.parse(eta!.replaceAll('s', ''));
      final minutes = (seconds / 60).ceil();
      if (minutes < 60) {
        return '$minutes min';
      } else {
        final hours = minutes ~/ 60;
        final remainingMinutes = minutes % 60;
        return '${hours}h ${remainingMinutes}m';
      }
    } catch (e) {
      return eta;
    }
  }

  Widget _buildStepIcon(int index, bool isCompleted, bool isActive) {
    Widget icon = Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isActive 
            ? Colors.white 
            : Colors.white.withOpacity(0.3),
        border: Border.all(
          color: isActive ? Colors.white : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: AppColors.primaryColor, size: 12.r)
            : isActive 
                ? Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
      ),
    );

    if (isActive) {
      return Pulse(
        infinite: true,
        duration: const Duration(seconds: 2),
        child: icon,
      );
    }
    return icon;
  }

  int _getCurrentStepIndex(String status) {
    switch (status) {
      case 'user_accept_offer':
        return 0;
      case 'payment_pending':
      case 'payment_processing':
        return 1;
      case 'assigned':
      case 'driver_on_a_way':
      case 'payment_paid':
        return 2;
      case 'arrived':
        return 3;
      case 'on_trip':
      case 'started':
        return 4;
      default:
        return 0;
    }
  }

  String _getDetailedStatusMessage(String status, S s) {
    switch (status) {
      case 'user_accept_offer':
        return s.offerAcceptedSub;
      case 'payment_pending':
        return s.paymentInitiated;
      case 'payment_processing':
        return s.bankConfirmation;
      case 'payment_paid':
        return s.finalizingBooking;
      case 'assigned':
      case 'driver_on_a_way':
        return s.driverHeadingToYou;
      case 'arrived':
        return s.arrivedDescription;
      case 'started':
      case 'on_trip':
        return s.onTripDescription;
      case 'payment_failed':
        return s.paymentFailedMsg;
      default:
        return s.offerAcceptedSub;
    }
  }
}
