import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_states.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentChanged;
  final bool useWallet;
  final ValueChanged<bool> onWalletToggled;

  const PaymentMethodWidget({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentChanged,
    required this.useWallet,
    required this.onWalletToggled,
  });

  static void showPaymentBottomSheet({
    required BuildContext context,
    required String selectedPaymentMethod,
    required ValueChanged<String> onPaymentChanged,
    required bool useWallet,
    required ValueChanged<bool> onWalletToggled,
  }) {
    bool currentUseWallet = useWallet;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext sheetContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PaymentCubit>()),
            BlocProvider.value(value: context.read<AuthCubit>()),
          ],
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (ctx, authState) {
              return StatefulBuilder(
                builder: (BuildContext sbContext, StateSetter setModalState) {
                  return SizedBox(
                    height: MediaQuery.of(ctx).size.height * 0.75,
                    child: _BottomSheetContent(
                      selectedPaymentMethod: selectedPaymentMethod,
                      onPaymentChanged: (val) {
                        onPaymentChanged(val);
                        Navigator.pop(ctx);
                      },
                      useWallet: currentUseWallet,
                      onWalletToggled: (val) {
                        setModalState(() {
                          currentUseWallet = val;
                        });
                        onWalletToggled(val);
                      },
                      onAddCard: () {
                         PaymentCubit.get(context).addCardIntent();
                         Navigator.pop(ctx);
                      }
                    ),
                  );
                }
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? AppColors.darkSecondary : AppColors.primaryColor;
    final bgColor = isDark
        ? Theme.of(context).colorScheme.surface
        : AppColors.primaryColor.withOpacity(0.1);

    final paymentCubit = context.watch<PaymentCubit>();
    String buttonText = S.of(context).cash;
    Widget buttonIconWidget = const SizedBox.shrink();

    if (selectedPaymentMethod == 'wallet') {
      buttonText = S.of(context).wallet;
      buttonIconWidget = Icon(Icons.account_balance_wallet, color: isDark ? AppColors.darkText : AppColors.primaryColor, size: 24.sp);
    } else if (selectedPaymentMethod == 'cash') {
      buttonText = S.of(context).cash;
      if (useWallet) {
        buttonText += ' + ${S.of(context).wallet}';
      }
      buttonIconWidget = SvgPicture.asset(
        'assets/svg/cash.svg',
        width: 24.sp,
        height: 24.sp,
        colorFilter: ColorFilter.mode(isDark ? AppColors.darkText : AppColors.primaryColor, BlendMode.srcIn)
      );
    } else {
      final cardIndex = paymentCubit.savedCards.indexWhere((c) => c.id.toString() == selectedPaymentMethod);
      if (cardIndex != -1) {
        final card = paymentCubit.savedCards[cardIndex];
        buttonText = card.maskedPan;
        buttonText = buttonText.length >= 4 ? '*${buttonText.substring(buttonText.length - 4)}' : buttonText;
        if (useWallet) {
          buttonText += ' + ${S.of(context).wallet}';
        }
        buttonIconWidget = getCardIcon(card.cardSubtype, isDark);
      } else {
        buttonText = S.of(context).cash;
        if (useWallet) {
          buttonText += ' + ${S.of(context).wallet}';
        }
        buttonIconWidget = SvgPicture.asset(
          'assets/svg/cash.svg',
          width: 24.sp,
          height: 24.sp,
          colorFilter: ColorFilter.mode(isDark ? AppColors.darkText : AppColors.primaryColor, BlendMode.srcIn)
        );
      }
    }

    return InkWell(
      onTap: () => showPaymentBottomSheet(
        context: context,
        selectedPaymentMethod: selectedPaymentMethod,
        onPaymentChanged: onPaymentChanged,
        useWallet: useWallet,
        onWalletToggled: onWalletToggled,
      ),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buttonIconWidget,
            8.pw,
            Text(
              buttonText,
              style: Styles.textStyle14(context).copyWith(
                color: isDark ? AppColors.darkText : AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentChanged;
  final bool useWallet;
  final ValueChanged<bool> onWalletToggled;
  final VoidCallback onAddCard;

  const _BottomSheetContent({
    required this.selectedPaymentMethod,
    required this.onPaymentChanged,
    required this.useWallet,
    required this.onWalletToggled,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final walletBalanceObj = authCubit.profileModel?.data?.walletAmount;
    final walletAmountStr = (walletBalanceObj?.toString() ?? '0.0').replaceAll(RegExp(r'[^0-9.]'), '');
    final walletBalance = double.tryParse(walletAmountStr) ?? 0.0;
    final isWalletEnabled = walletBalance > 0.0;
    final displayBalance = walletBalanceObj?.toString() ?? '0.00';

    return Container(
      padding: EdgeInsets.all(20.r),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            20.ph,
            Text(
              S.of(context).selectPaymentMethod,
              style: Styles.textStyle18Bold(context),
            ),
            20.ph,
            
            // Wallet Section
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isWalletEnabled 
                    ? AppColors.primaryColor.withOpacity(0.05) 
                    : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: useWallet
                      ? AppColors.primaryColor 
                      : Colors.grey.withOpacity(0.2)
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: isWalletEnabled 
                          ? AppColors.primaryColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: isWalletEnabled ? AppColors.primaryColor : Colors.grey,
                      size: 24.sp,
                    ),
                  ),
                  12.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).wallet,
                          style: Styles.textStyle16(context).copyWith(
                            color: isWalletEnabled ? null : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$displayBalance EGP',
                          style: Styles.textStyle14(context).copyWith(
                            color: isWalletEnabled ? AppColors.primaryColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: useWallet,
                    onChanged: isWalletEnabled ? onWalletToggled : null,
                    activeColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
            
            Divider(height: 40.h),
            
            // Cash Option
            _buildPaymentOption(
              context,
              customIcon: SvgPicture.asset(
                'assets/svg/cash.svg',
                width: 24.sp,
                height: 24.sp,
                colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)
              ),
              title: S.of(context).cash,
              value: 'cash',
            ),
            
            10.ph,
            Text(
              S.of(context).savedCards,
              style: Styles.textStyle16Bold(context),
            ),
            10.ph,
            
            // Saved Cards List
            BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                final paymentCubit = PaymentCubit.get(context);
                final cards = paymentCubit.savedCards;
                
                if (state is GetSavedCardsLoading && cards.isEmpty) {
                   return const Center(child: CircularProgressIndicator());
                }
                
                return Column(
                  children: cards.map((card) {
                    final pan = card.maskedPan;
                    final displayPan = pan.length >= 4 ? '*${pan.substring(pan.length - 4)}' : pan;
                    return _buildPaymentOption(
                      context,
                      customIcon: getCardIcon(card.cardSubtype, false),
                      title: displayPan,
                      value: card.id.toString(),
                    );
                  }).toList(),
                );
              },
            ),
            
            20.ph,
            
            // Add New Method
            InkWell(
              onTap: onAddCard,
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline,
                      color: AppColors.primaryColor, size: 24.sp),
                  10.pw,
                  Text(
                    S.of(context).addNewCard,
                    style: Styles.textStyle16(context)
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    Widget? customIcon,
    IconData? icon,
    required String title,
    required String value,
  }) {
    final bool isSelected = selectedPaymentMethod == value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: customIcon ?? Icon(icon, color: AppColors.primaryColor, size: 24.sp),
      ),
      title: Text(title, style: Styles.textStyle16(context)),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primaryColor)
          : null,
      onTap: () {
        onPaymentChanged(value);
      },
    );
  }
}

Widget getCardIcon(String? subtype, bool isDark) {
  if (subtype == null) return SvgPicture.asset('assets/svg/card.svg', width: 24.sp, height: 24.sp, colorFilter: ColorFilter.mode(isDark ? AppColors.darkText : AppColors.primaryColor, BlendMode.srcIn));
  final st = subtype.toLowerCase();
  if (st.contains('visa')) {
    return Icon(FontAwesomeIcons.ccVisa, color: const Color(0xFF1434CB), size: 24.sp);
  } else if (st.contains('master')) {
    return SvgPicture.asset('assets/svg/mastercard.svg', width: 24.sp, height: 24.sp);
  } else if (st.contains('mada')) {
    return SvgPicture.asset('assets/svg/mada.svg', width: 24.sp, height: 24.sp);
  } else {
    return SvgPicture.asset('assets/svg/card.svg', width: 24.sp, height: 24.sp, colorFilter: ColorFilter.mode(isDark ? AppColors.darkText : AppColors.primaryColor, BlendMode.srcIn));
  }
}

