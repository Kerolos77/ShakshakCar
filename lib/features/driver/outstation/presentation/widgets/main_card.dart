import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/features/driver/outstation/presentation/widgets/user_row.dart';

import '../../../../../core/utils/shared_widgets/custom_button.dart';
import '../../../../../core/utils/shared_widgets/ride_destination_widget.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../user/user_home/domain/entities/new_ride_data_entity.dart';
import '../../../new_rides/domain/entities/negotiation_settings_entity.dart';
import 'bid_button.dart';
import 'header_row.dart';
import 'outstation_info.dart';

/// الكارت الأساسي (مفصول لتقليل زحمة الـ build في الـ State)
class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.ride,
    required this.isNew,
    required this.isOutstation,
    required this.currentAmount,
    required this.isAnyActionLoading,
    required this.isOfferPending,
    required this.onBid,
    required this.onPrimaryAction,
    required this.onDismiss,
    required this.onCancelOffer,
    required this.isOtpVerified,
    this.isDeliveryOtpVerified = false,
    this.onCancelTrip,
    this.onVerifyOtp,
    this.onVerifyDeliveryOtp,
    this.negotiationSettings,
    this.showDetailsButton = true,
    this.showDismissButton = true,
  });

  final NewRideDataEntity ride;
  final bool isNew;
  final bool isOutstation;
  final double currentAmount;
  final bool isAnyActionLoading;
  final bool isOfferPending;
  final bool showDetailsButton;
  final bool showDismissButton;
  final NegotiationSettingsEntity? negotiationSettings;

  final void Function(double delta) onBid;
  final VoidCallback onPrimaryAction;
  final VoidCallback onDismiss;
  final VoidCallback onCancelOffer;
  final VoidCallback? onCancelTrip;
  final bool isOtpVerified;
  final bool isDeliveryOtpVerified;
  final void Function(String otp)? onVerifyOtp;
  final void Function(String otp)? onVerifyDeliveryOtp;

  @override
  Widget build(BuildContext context) {
    final baseAmount = ride.amount.toDouble();
    final hasNewPrice = currentAmount != baseAmount;

    final bool isTripActive = ride.status == 'accepted' ||
        ride.status == 'assigned' ||
        ride.status == 'driver_on_a_way' ||
        ride.status == 'arrived' ||
        ride.status == 'started' ||
        ride.status == 'on_trip';

    final bool isDeliveryOtpRequired = (ride.status == 'started' || ride.status == 'on_trip') &&
        (ride.deliveryOtp != null && ride.deliveryOtp!.isNotEmpty);

    // حالة القفل: لو في لودينج أو لو في عرض معلق فعلاً
    final bool isInteractionDisabled = isAnyActionLoading || isOfferPending;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress للـ ride الجديد تم إزالته بطلب المستخدم

                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      // Header: المسافة + نوع الدفع + السعر القديم + Dismiss Button
                      HeaderRow(
                        ride: ride,
                        currentAmount: currentAmount,
                        onDismiss: onDismiss,
                        showDismissButton: showDismissButton,
                      ),

                      8.ph,

                      // User info + fare
                      UserRow(
                        ride: ride,
                        currentAmount: currentAmount,
                        isAnyActionLoading: isInteractionDisabled,
                        showDetailsButton: showDetailsButton,
                      ),

                      10.ph,

                      RideDestinationWidget(
                        from: ride.sourceAddress.isNotEmpty
                            ? ride.sourceAddress
                            : S.of(context).unknownLocation,
                        to: ride.destinationAddress.isNotEmpty
                            ? ride.destinationAddress
                            : S.of(context).unknownLocation,
                      ),

                      // outstation parcel info
                      if (isOutstation) OutstationInfo(ride: ride),

                      12.ph,

                      // Bidding buttons
                      if (!isTripActive &&
                          negotiationSettings != null &&
                          negotiationSettings!.data.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: negotiationSettings!.data.map((valueStr) {
                              final doubleValue =
                                  double.tryParse(valueStr) ?? 0.0;
                              if (doubleValue == 0.0) {
                                return const SizedBox.shrink();
                              }

                              String label;
                              double delta;
                              if (negotiationSettings!.activeType ==
                                  'percentage_increase') {
                                delta = (baseAmount * (doubleValue / 100))
                                    .roundToDouble();
                                label = '+${delta.toInt()}';
                              } else {
                                delta = doubleValue.roundToDouble();
                                label = '+${delta.toInt()}';
                              }

                              return Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: BidButton(
                                    label: label,
                                    disabled: isInteractionDisabled,
                                    onTap: () => onBid(delta),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      // Reset to Original Price Button
                      if (!isTripActive && hasNewPrice && !isInteractionDisabled)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Center(
                            child: InkWell(
                              onTap: () => onBid(0),
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.refresh_rounded,
                                        size: 18.r,
                                        color: Theme.of(context).hintColor),
                                    6.pw,
                                    Text(
                                      "إستعادة السعر الأصلي",
                                      style: Styles.textStyle14Medium(context)
                                          .copyWith(
                                              color:
                                                  Theme.of(context).hintColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      // OTP input field if status is arrived
                      if (ride.status == 'arrived') ...[
                        10.ph,
                        if (!isOtpVerified) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "أدخل رمز التحقق (OTP) لبدء الرحلة:${ride.pickupOtp != null && ride.pickupOtp!.isNotEmpty ? ' (رمز الفحص: ${ride.pickupOtp})' : ''}",
                              style: Styles.textStyle14SemiBold(context).copyWith(
                                color: Styles.getPrimaryColor(context),
                              ),
                            ),
                          ),
                          10.ph,
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Center(
                              child: Pinput(
                                length: 4,
                                autofillHints: const [AutofillHints.oneTimeCode],
                                defaultPinTheme: PinTheme(
                                  width: 40.w,
                                  height: 46.h,
                                  textStyle: Styles.textStyle18Medium(context).copyWith(
                                    color: Styles.getPrimaryColor(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  width: 40.w,
                                  height: 46.h,
                                  textStyle: Styles.textStyle18Medium(context).copyWith(
                                    color: Styles.getPrimaryColor(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Styles.getPrimaryColor(context), width: 1.5),
                                  ),
                                ),
                                onCompleted: (pin) {
                                  if (onVerifyOtp != null) {
                                    onVerifyOtp!(pin);
                                  }
                                },
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                10.pw,
                                Text(
                                  "تم التحقق من رمز العميل بنجاح",
                                  style: Styles.textStyle14Bold(context).copyWith(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                        12.ph,
                      ],

                      // Delivery OTP input field if status is started/on_trip and has deliveryOtp
                      if (isDeliveryOtpRequired) ...[
                        10.ph,
                        if (!isDeliveryOtpVerified) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "أدخل رمز التحقق للمستلم (OTP) لإنهاء الرحلة:${ride.deliveryOtp != null && ride.deliveryOtp!.isNotEmpty ? ' (رمز الفحص: ${ride.deliveryOtp})' : ''}",
                              style: Styles.textStyle14SemiBold(context).copyWith(
                                color: Styles.getPrimaryColor(context),
                              ),
                            ),
                          ),
                          10.ph,
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Center(
                              child: Pinput(
                                length: 4,
                                autofillHints: const [AutofillHints.oneTimeCode],
                                defaultPinTheme: PinTheme(
                                  width: 40.w,
                                  height: 46.h,
                                  textStyle: Styles.textStyle18Medium(context).copyWith(
                                    color: Styles.getPrimaryColor(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  width: 40.w,
                                  height: 46.h,
                                  textStyle: Styles.textStyle18Medium(context).copyWith(
                                    color: Styles.getPrimaryColor(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Styles.getPrimaryColor(context), width: 1.5),
                                  ),
                                ),
                                onCompleted: (pin) {
                                  if (onVerifyDeliveryOtp != null) {
                                    onVerifyDeliveryOtp!(pin);
                                  }
                                },
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                10.pw,
                                Text(
                                  "تم التحقق من رمز المستلم بنجاح",
                                  style: Styles.textStyle14Bold(context).copyWith(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                        12.ph,
                      ],

                      // Primary button / Active Trip Buttons
                      if (isTripActive)
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomButton(
                                text: ride.status == 'accepted' ||
                                        ride.status == 'assigned' ||
                                        ride.status == 'driver_on_a_way'
                                    ? "لقد وصلت"
                                    : (ride.status == 'arrived'
                                        ? S.of(context).startTrip
                                        : S.of(context).endTrip),
                                onTap: isAnyActionLoading
                                    ? null
                                    : (ride.status == 'arrived' && !isOtpVerified
                                        ? null
                                        : (isDeliveryOtpRequired && !isDeliveryOtpVerified
                                            ? null
                                            : onPrimaryAction)),
                                buttonColor: (ride.status == 'arrived' && !isOtpVerified) ||
                                        (isDeliveryOtpRequired && !isDeliveryOtpVerified)
                                    ? Theme.of(context).disabledColor
                                    : Styles.getPrimaryColor(context),
                                height: 55.h,
                                borderRadius: 12.r,
                              ),
                            ),
                            12.pw,
                            Expanded(
                              flex: 1,
                              child: CustomButton(
                                text: "إلغاء",
                                onTap: isAnyActionLoading ? null : onCancelTrip,
                                buttonColor: Colors.red.withOpacity(0.8),
                                height: 55.h,
                                borderRadius: 12.r,
                              ),
                            ),
                          ],
                        )
                      else
                        CustomButton(
                          text: isOfferPending
                              ? "إلغاء العرض"
                              : (hasNewPrice
                                  ? S.of(context).raiseFare
                                  : S.of(context).accept),
                          onTap: isAnyActionLoading
                              ? null
                              : (isOfferPending
                                  ? onCancelOffer
                                  : onPrimaryAction),
                          buttonColor: isOfferPending
                              ? Colors.red.withOpacity(0.8)
                              : Styles.getPrimaryColor(context),
                          height: 55.h,
                          borderRadius: 12.r,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
