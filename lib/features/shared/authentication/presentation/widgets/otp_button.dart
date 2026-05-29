import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';

class OtpButton extends StatelessWidget {
  const OtpButton({
    super.key,
    required this.otpController,
    required this.formKey,
    required this.phoneNumber,
  });

  final TextEditingController otpController;
  final GlobalKey<FormState> formKey;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerifyPhoneOTPSuccessState) {
          if (state.otpModel.statusval == true) {
            showSnackBar(
                context,
                state.otpModel.msg!,
                S.of(context).doneSuccessfully,
                AppColors.primaryColor,
                ContentType.success);
            if (state.otpModel.data?.isDriver == 0) {
              navigateAndFinish(context, Routes.userHomeView);
            } else {
              navigateAndFinish(context, Routes.driverHomeView);
            }
          } else {
            if (state.otpModel.msg! == 'messages.user notfound') {
              showSnackBar(
                  context,
                  state.otpModel.msg!,
                  S.of(context).errorOccurred,
                  AppColors.redColor,
                  ContentType.failure);

              navigateAndFinish(context, Routes.registerView,
                  extra: RegisterRouteArgs(phoneNumber: phoneNumber));
            } else {
              showSnackBar(
                  context,
                  state.otpModel.msg!,
                  S.of(context).errorOccurred,
                  AppColors.redColor,
                  ContentType.failure);
            }
          }
        } else if (state is VerifyPhoneOTPErrorState) {
          showSnackBar(context, state.errorMsg, S.of(context).errorOccurred,
              AppColors.redColor, ContentType.failure);
        }
      },
      builder: (context, state) {
        if (state is! VerifyPhoneOTPLoadingState) {
          return CustomButton(
            text: S.of(context).activate,
            onTap: () {
              print("${phoneNumber}pp=============================");
              if (formKey.currentState!.validate()) {
                context.read<AuthCubit>().verifyPhoneOtp(
                      otpCode: int.parse(otpController.text),
                    );
              }
            },
          );
        } else {
          return const CustomLoadingButton();
        }
      },
    );
  }
}
