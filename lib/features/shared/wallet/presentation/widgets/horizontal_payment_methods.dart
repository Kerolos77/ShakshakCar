import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';
import 'package:shakshak/features/shared/payment/presentation/widgets/payment_card_item.dart';
import 'package:shakshak/generated/l10n.dart';

class HorizontalPaymentMethods extends StatelessWidget {
  final List<SavedCardEntity> cards;
  final VoidCallback onAddCard;
  final Function(String) onDeleteCard;
  final Function(SavedCardEntity)? onCardTap;

  const HorizontalPaymentMethods({
    super.key,
    required this.cards,
    required this.onAddCard,
    required this.onDeleteCard,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).savedCards,
                style: Styles.textStyle16Bold(context),
              ),
              TextButton(
                onPressed: onAddCard,
                child: Text(
                  S
                      .of(context)
                      .addNewCard, // Changed from Select Payment Method
                  style: Styles.textStyle14SemiBold(context).copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (cards.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: GestureDetector(
              onTap: onAddCard,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGreyColor),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_card_rounded,
                        color: AppColors.greyColor, size: 24.r),
                    SizedBox(width: 8.w),
                    Text(
                      S
                          .of(context)
                          .addNewCard, // Changed from Select Payment Method
                      style: Styles.textStyle14(context).copyWith(
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 85.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 140.w,
                  child: PaymentCardItem(
                    card: cards[
                        index], // Assuming PaymentCardItem can take SavedCardEntity or has an adapter
                    isSelected: false,
                    onTap: () {
                      if (onCardTap != null) {
                        onCardTap!(cards[index]);
                      }
                    },
                    onDelete: () => onDeleteCard(cards[index].id.toString()),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
