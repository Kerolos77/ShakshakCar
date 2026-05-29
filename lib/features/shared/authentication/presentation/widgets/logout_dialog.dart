import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_animated_dialog.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        loginUseCase: sl(),
        signupUseCase: sl(),
        verifyPhoneOtpUseCase: sl(),
        getProfileUseCase: sl(),
        updateProfileUseCase: sl(),
      ),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomAnimatedDialog(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Text(
                  S.of(context).logoutConfirmation,
                  style: Styles.textStyle16Medium(context).copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  text: S.of(context).logout,
                  onTap: () {
                    context.read<AuthCubit>().logout();
                    showSnackBar(
                        context,
                        S.of(context).logoutSuccessMessage,
                        S.of(context).doneSuccessfully,
                        AppColors.secondaryColor,
                        ContentType.success);
                    navigateAndFinish(context, Routes.loginView);
                  },
                ),
                TextButton(
                  onPressed: () => navigatePop(context),
                  child: Text(
                    S.of(context).close,
                    style: Styles.textStyle12SemiBold(context).copyWith(
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
