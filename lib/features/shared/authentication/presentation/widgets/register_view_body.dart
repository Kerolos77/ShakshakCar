import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_drop_down.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/phone_text_field.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/validations.dart';
import 'package:shakshak/generated/assets.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/country_city_cubit/countries_cities_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/widgets/register_button.dart';
import 'cities_drop_down.dart';
import 'have_an_account_widget.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  String gender = 'male';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? selectedCountryId;
  int? selectedCityId;
  int? selectedDistrictId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final authCubit = context.read<AuthCubit>();
        authCubit.phoneController.text = widget.phoneNumber;
        authCubit.changeCompleteNumber(
          completeNumber: widget.phoneNumber,
          countryCode: '+20',
        );
        setState(() {});
      }
    });

    // Trigger loading countries
    final cubit = context.read<CountriesCitiesCubit>();
    if (cubit.state is! CountrySuccess) {
      cubit.getCountries();
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CountriesCitiesCubit, CountriesCitiesState>(
      listener: (context, state) {
        final cubit = context.read<CountriesCitiesCubit>();
        if (cubit.selectedCountryId != null &&
            cubit.selectedCountryId != selectedCountryId) {
          setState(() {
            selectedCountryId = cubit.selectedCountryId;
          });
        }
      },
      child: SingleChildScrollView(
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
                        6.ph,
                        FadeIn(
                          delay: const Duration(milliseconds: 400),
                          child: Container(
                            height: 1.5.h,
                            width: 50.w,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        6.ph,
                        FadeIn(
                          delay: const Duration(milliseconds: 600),
                          child: Text(
                            'C A R',
                            style: Styles.textStyle18SemiBold(context).copyWith(
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 6,
                              fontSize: 16.sp,
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
                  24.ph,
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).signup,
                          style: Styles.textStyle28Bold(context).copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        8.ph,
                        Text(
                          S
                              .of(context)
                              .welcomeBack, // Or appropriate "Create Account" text if available
                          style: Styles.textStyle16(context).copyWith(
                            color: AppColors.darkGreyColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.ph,
                  Form(
                    key: formKey,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: userNameController,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: Validation.validateName(context),
                            prefix: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: SvgPicture.asset(Assets.svgUser),
                            ),
                            hint: S.of(context).userName,
                          ),
                          16.ph,
                          PhoneTextField(
                            controller:
                                context.read<AuthCubit>().phoneController,
                          
                          ),
                          16.ph,
                          CustomTextField(
                            controller: emailController,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: Validation.validateEmail(context),
                            keyType: TextInputType.emailAddress,
                            prefix: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: SvgPicture.asset(Assets.svgEmail),
                            ),
                            hint: S.of(context).email,
                          ),
                          16.ph,
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropDown(
                                  items: [
                                    S.of(context).male,
                                    S.of(context).female
                                  ],
                                  hint: S.of(context).gender,
                                  value: gender == 'male'
                                      ? S.of(context).male
                                      : gender == 'female'
                                          ? S.of(context).female
                                          : null,
                                  onChange: (value) {
                                    setState(() {
                                      if (value == S.of(context).male) {
                                        gender = 'male';
                                      } else if (value ==
                                          S.of(context).female) {
                                        gender = 'female';
                                      }
                                    });
                                  },
                                  prefix: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Icon(Icons.person_outline,
                                        color: AppColors.secondaryColor),
                                  ),
                                ),
                              ),
                              16.pw,
                              Expanded(
                                child: CustomTextField(
                                  controller: referralCodeController,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  hint: S.of(context).referralCode,
                                  prefix: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Icon(Icons.code,
                                        color: AppColors.secondaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          16.ph,
                          CitiesDropDown(
                            initialCountryId: selectedCountryId,
                            onCountrySelected: (countryId) {
                              setState(() {
                                selectedCountryId = countryId;
                                selectedCityId = null;
                                selectedDistrictId = null;
                              });
                            },
                            onCitySelected: (cityId) {
                              setState(() {
                                selectedCityId = cityId;
                              });
                            },
                            onDistrictSelected: (districtId) {
                              setState(() {
                                selectedDistrictId = districtId;
                              });
                            },
                          ),
                          32.ph,
                          RegisterButton(
                              userNameController: userNameController,
                              emailController: emailController,
                              referralCodeController: referralCodeController,
                              gender: gender,
                              formKey: formKey),
                          16.ph,
                          HaveAnAccountWidget(),
                          32.ph
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
