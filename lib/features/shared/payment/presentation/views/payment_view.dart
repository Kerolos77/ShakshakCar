import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_states.dart';
import 'package:shakshak/features/shared/payment/presentation/widgets/payment_card_item.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(sl(), sl(), sl(), sl(), sl())..getSavedCards(),
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          final cubit = PaymentCubit.get(context);
          return Scaffold(
            body: BaseLayoutView(
              title: S.of(context).savedCards,
              body: Padding(
                padding: EdgeInsets.all(16.r),
                child: state is GetSavedCardsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : cubit.savedCards.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.credit_card_off,
                                    size: 80.r, color: Colors.grey[300]),
                                SizedBox(height: 16.h),
                                Text(S.of(context).noData,
                                    style: Styles.textStyle16(context)
                                        .copyWith(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: cubit.savedCards.length,
                            itemBuilder: (context, index) {
                              final card = cubit.savedCards[index];
                              return PaymentCardItem(
                                card: card,
                                isSelected: false,
                                onTap: () {},
                                onDelete: () {
                                  cubit.deleteCard(card.id.toString());
                                },
                              );
                            },
                          ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigateTo(
                  context,
                  Routes.addCardView,
                  extra: cubit,
                );
              },
              backgroundColor: AppColors.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
