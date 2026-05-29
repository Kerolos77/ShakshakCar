import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/validations.dart';
import 'package:shakshak/generated/l10n.dart';

import 'otp_button.dart';

class OtpViewBody extends StatefulWidget {
  const OtpViewBody({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 56.h,
      textStyle: Styles.textStyle22Medium(context).copyWith(
        color: AppColors.primaryColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            height: 300.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withAlpha(200),
                  AppColors.secondaryColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.r),
                bottomRight: Radius.circular(50.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background decorative circles
                Positioned(
                  top: -30.h,
                  right: -30.w,
                  child: FadeIn(
                    duration: const Duration(seconds: 2),
                    child: Container(
                      width: 200.w,
                      height: 200.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40.h,
                  left: -40.w,
                  child: FadeIn(
                    duration: const Duration(seconds: 2),
                    child: Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Premium Typography Logo
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'auth_logo',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Image.asset(
                            'assets/images/logo_dark.png',
                            height: 100.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -30.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      S.of(context).verification,
                      style: Styles.textStyle24Bold(context).copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  8.ph,
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      S.of(context).enterTheCodeSentToYourPhone,
                      style: Styles.textStyle16Medium(context).copyWith(
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                  ),
                  8.ph,
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      widget.phoneNumber,
                      style: Styles.textStyle16Bold(context).copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                40.ph,
                Form(
                  key: formKey,
                  child: FadeIn(
                    duration: const Duration(milliseconds: 800),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        controller: otpController,
                        length: 6,
                        obscureText: false,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        onClipboardFound: (value) {
                          debugPrint('onClipboardFound: $value');
                          otpController.setText(value);
                        },
                        validator: Validation.validateOTP(context),
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        onCompleted: (value) {
                          debugPrint(otpController.text);
                        },
                      ),
                    ),
                  ),
                ),
                60.ph,
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: OtpButton(
                    otpController: otpController,
                    formKey: formKey,
                    phoneNumber: widget.phoneNumber,
                  ),
                ),
                24.ph,
                /* ResendOtp(), */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
