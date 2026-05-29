import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/saved_cards/saved_cards_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/saved_cards/saved_cards_state.dart';
import 'package:shakshak/generated/l10n.dart';

class SavedCardsBottomSheet extends StatelessWidget {
  final double amount;
  final int orderId;
  final VoidCallback onSuccess;

  const SavedCardsBottomSheet({
    super.key,
    required this.amount,
    required this.orderId,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedCardsCubit(
        fetchSavedCardsUseCase: sl(),
        payWithSavedCardUseCase: sl(),
      )..fetchSavedCards(),
      child: BlocConsumer<SavedCardsCubit, SavedCardsState>(
        listener: (context, state) {
          if (state is PayWithSavedCardSuccess) {
            Navigator.pop(context); // Close sheet
            onSuccess(); // Trigger navigation or success logic
          } else if (state is PayWithSavedCardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(16.r),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Pay With Saved Card", // Fallback for l10n
                  style: Styles.textStyle20Bold(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                if (state is SavedCardsLoading)
                  const Expanded(child: Center(child: CustomLoading()))
                else if (state is SavedCardsError)
                  Expanded(child: Center(child: Text(state.message)))
                else if (state is SavedCardsLoaded)
                  Expanded(
                    child: state.cards.isEmpty
                        ? const Center(child: Text("No data available"))
                        : ListView.builder(
                            itemCount: state.cards.length,
                            itemBuilder: (context, index) {
                              final card = state.cards[index];
                              return _CardItem(
                                card: card,
                                onTap: () {
                                  _showConfirmationDialog(
                                    context,
                                    card,
                                    context.read<SavedCardsCubit>(),
                                  );
                                },
                              );
                            },
                          ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, SavedCardEntity card, SavedCardsCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text(
            'Pay $amount with ${card.cardSubtype} ending in ${card.maskedPan.substring(card.maskedPan.length - 4)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).cancel),
          ),
          BlocProvider.value(
            value: cubit,
            child: BlocBuilder<SavedCardsCubit, SavedCardsState>(
              builder: (context, state) {
                if (state is PayWithSavedCardLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }
                return TextButton(
                  onPressed: () {
                    cubit.payWithCard(
                      savedCardId: card.id,
                      amount: amount,
                      orderId: orderId,
                    );
                    Navigator.pop(ctx);
                  },
                  child: Text(S.of(context).pay,
                      style: const TextStyle(color: AppColors.primaryColor)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final SavedCardEntity card;
  final VoidCallback onTap;

  const _CardItem({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.credit_card, color: AppColors.primaryColor),
        title: Text(
            '**** **** **** ${card.maskedPan.substring(card.maskedPan.length - 4)}',
            style: Styles.textStyle16Bold(context).copyWith(letterSpacing: 2)),
        subtitle: Text('Expires ${card.expiryMonth}/${card.expiryYear}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
