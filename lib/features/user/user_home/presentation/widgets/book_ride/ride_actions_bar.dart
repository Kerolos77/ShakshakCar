import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'payment_method_widget.dart';

class RideActionsBar extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentChanged;
  final bool useWallet;
  final ValueChanged<bool> onWalletToggled;
  final VoidCallback onConfirmTap;
  final bool isLoading;

  const RideActionsBar({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentChanged,
    required this.useWallet,
    required this.onWalletToggled,
    required this.onConfirmTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(16.0.r),
      child: Row(
        children: [
          // Payment Method Widget
          PaymentMethodWidget(
            selectedPaymentMethod: selectedPaymentMethod,
            onPaymentChanged: onPaymentChanged,
            useWallet: useWallet,
            onWalletToggled: onWalletToggled,
          ),
          SizedBox(width: 10.w),
          // Confirm Button
          Expanded(
            child: CustomButton(
              buttonColor:
                  isDark ? AppColors.darkPrimary : AppColors.primaryColor,
              borderColor:
                  isDark ? AppColors.darkSecondary : AppColors.transparent,
              textColor: isDark
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.white,
              onTap: onConfirmTap,
              isLoading: isLoading,
              text: S.of(context).confirmOrder,
            ),
          ),
        ],
      ),
    );
  }
}
