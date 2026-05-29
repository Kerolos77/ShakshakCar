import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/features/shared/authentication/data/models/signup_body.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.userNameController,
    required this.emailController,
    required this.referralCodeController,
    required this.gender,
    required this.formKey,
  });

  final TextEditingController userNameController,
      emailController,
      referralCodeController;
  final String gender;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          if (state.userModel.statusval == true) {
            showSnackBar(
                context,
                state.userModel.msg ?? '',
                S.of(context).doneSuccessfully,
                AppColors.primaryColor,
                ContentType.success);
            if (state.userModel.data?.isDriver == 0) {
              navigateAndFinish(context, Routes.userHomeView);
            } else {
              navigateAndFinish(context, Routes.driverHomeView);
            }
          } else {
            showSnackBar(
              context,
              state.userModel.msg ?? '',
              S.of(context).errorOccurred,
              AppColors.redColor,
              ContentType.failure,
            );
          }
        }
      },
      builder: (context, state) {
        if (state is! RegisterLoadingState) {
          return CustomButton(
            text: S.of(context).signup,
            onTap: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthCubit>().signup(
                      signupBody: SignupBody(
                        userName: userNameController.text,
                        email: emailController.text,
                        phoneNumber: context.read<AuthCubit>().completeNumber,
                        countryCode: context.read<AuthCubit>().countryCode,
                        referralCode: referralCodeController.text,
                        gender: gender,
                      ),
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
