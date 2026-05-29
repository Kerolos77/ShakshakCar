import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/core/utils/shared_widgets/phone_text_field.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'login_button.dart';
import 'terms_and_conditions_widget.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Gradient and Illustration
          Container(
            height: 380.h,
            width: double.infinity,
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
                bottomLeft: Radius.circular(60.r),
                bottomRight: Radius.circular(60.r),
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
                  top: -40.h,
                  right: -40.w,
                  child: FadeIn(
                    duration: const Duration(seconds: 2),
                    child: Container(
                      width: 250.w,
                      height: 250.w,
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
                  bottom: 60.h,
                  left: -50.w,
                  child: FadeIn(
                    duration: const Duration(seconds: 2),
                    child: Container(
                      width: 180.w,
                      height: 180.w,
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
                          borderRadius: BorderRadius.circular(24.r),
                          child: Image.asset(
                            'assets/images/logo_dark.png',
                            height: 120.h,
                          ),
                        ),
                      ),
                      8.ph,
                      FadeIn(
                        delay: const Duration(milliseconds: 400),
                        child: Container(
                          height: 2.h,
                          width: 60.w,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      8.ph,
                      FadeIn(
                        delay: const Duration(milliseconds: 600),
                        child: Text(
                          'C A R',
                          style: Styles.textStyle18SemiBold(context).copyWith(
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.ph,
                // Greeting Section
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).login,
                        style: Styles.textStyle30Bold(context).copyWith(
                          color: AppColors.primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      8.ph,
                      Text(
                        S.of(context).welcomeBack,
                        style: Styles.textStyle16(context).copyWith(
                          color: AppColors.darkGreyColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                32.ph,

                // Input Section
                Form(
                  key: formKey,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: PhoneTextField(
                            controller:
                                context.read<AuthCubit>().phoneController,
                          ),
                        ),
                        32.ph,
                        LoginButton(
                          emailOrPhoneController:
                              context.read<AuthCubit>().phoneController,
                          formKey: formKey,
                        ),
                        24.ph,
                        Center(child: TermsAndConditionsWidget()),
                        20.ph,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
