import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_states.dart';
import 'package:shakshak/generated/l10n.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  // UI logic moved out for intents instead of manual entry

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is AddCardRequiresWebView) {
          Navigator.pop(
              context); // Close add card screen initially maybe? No, route over it
          context.pushReplacement(
            Routes.ridePaymentWebView,
            extra: RidePaymentWebViewArgs(
              checkoutUrl: state.checkoutUrl,
              orderId: int.tryParse(state.orderId) ?? 0,
              isAddingCard: true, // we also need this flag to handle routing!
            ),
          );
        } else if (state is AddCardFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return BaseLayoutView(
          title: S.of(context).addNewCard,
          body: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card,
                    size: 80.r, color: AppColors.primaryColor),
                20.ph,
                Text(
                  "A nominal fee of 1 EGP will be deducted to securely add your card. This amount will be added instantly to your app Wallet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
                40.ph,
                state is AddCardLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: "Proceed to Add Card",
                        buttonColor: AppColors.primaryColor,
                        onTap: () {
                          PaymentCubit.get(context).addCardIntent();
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
