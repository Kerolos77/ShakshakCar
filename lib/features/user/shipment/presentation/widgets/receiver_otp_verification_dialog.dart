import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/generated/l10n.dart';

class ReceiverOtpVerificationDialog extends StatefulWidget {
  final NewRideDataEntity newRideData;
  final String fallbackPhone;

  const ReceiverOtpVerificationDialog({
    super.key,
    required this.newRideData,
    required this.fallbackPhone,
  });

  static Future<void> show(
    BuildContext context, {
    required NewRideDataEntity newRideData,
    required String fallbackPhone,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: BlocProvider.value(
          value: context.read<UserHomeCubit>(),
          child: ReceiverOtpVerificationDialog(
            newRideData: newRideData,
            fallbackPhone: fallbackPhone,
          ),
        ),
      ),
    );
  }

  @override
  State<ReceiverOtpVerificationDialog> createState() =>
      _ReceiverOtpVerificationDialogState();
}

class _ReceiverOtpVerificationDialogState
    extends State<ReceiverOtpVerificationDialog> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiverPhone = widget.newRideData.receiverPhone?.isNotEmpty == true
        ? widget.newRideData.receiverPhone!
        : widget.fallbackPhone;

    return BlocConsumer<UserHomeCubit, UserHomeState>(
      listener: (dialogContext, state) {
        if (state is VerifyReceiverOtpSuccess) {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext, rootNavigator: true).pop();
          }
          if (context.mounted) {
            showSnackBar(
              context,
              state.message,
              S.of(context).doneSuccessfully,
              AppColors.primaryColor,
              ContentType.success,
            );
            navigateAndFinish(
              context,
              Routes.userHomeView,
            );
          }
        } else if (state is VerifyReceiverOtpFailure) {
          if (dialogContext.mounted) {
            showSnackBar(
              dialogContext,
              state.errorMessage,
              S.of(context).errorOccurred,
              AppColors.redColor,
              ContentType.failure,
            );
          }
        }
      },
      builder: (dialogContext, state) {
        final isLoading = state is VerifyReceiverOtpLoading;
        final defaultPinTheme = PinTheme(
          width: 50.w,
          height: 56.h,
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primaryColor),
              SizedBox(width: 8),
              Text(
                "تأكيد رقم المستلم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تم إرسال كود تأكيد مكون من 4 أرقام عبر SMS إلى رقم المستلم ($receiverPhone). يرجى التواصل معه وإدخال الكود لبدء استقبال عروض الكباتن.",
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),
              Center(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: _otpController,
                    length: 4,
                    enabled: !isLoading,
                    autofocus: true,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    onClipboardFound: (value) {
                      _otpController.setText(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        final otp = _otpController.text.trim();
                        if (otp.length == 4) {
                          dialogContext.read<UserHomeCubit>().verifyReceiverOtp(
                                orderId: widget.newRideData.id,
                                otp: otp,
                              );
                        } else {
                          showSnackBar(
                            dialogContext,
                            "يرجى إدخال كود مكون من 4 أرقام",
                            S.of(context).errorOccurred,
                            AppColors.redColor,
                            ContentType.failure,
                          );
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "تأكيد الكود",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
