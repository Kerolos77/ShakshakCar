import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';

class PaymentCardItem extends StatelessWidget {
  final SavedCardEntity card;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PaymentCardItem({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    IconData cardIcon = getCardIcon(
      cardSubtype: card.cardSubtype,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : AppColors.lightGreyColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(cardIcon,
                  color: Theme.of(context).primaryColor, size: 20.sp),
            ),
            SizedBox(width: 4.w),
            // Details
            Expanded(
              child: Text(
                _formatCardNumber(card.maskedPan),
                style: Styles.textStyle14Bold(context).copyWith(
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Delete Button
            InkWell(
              onTap: onDelete,
              child: Icon(Icons.delete_outline,
                  color: AppColors.redColor, size: 24.sp),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCardNumber(String number) {
    if (number.length >= 4) {
      return number.substring(number.length - 4);
    }
    return number;
  }

  IconData getCardIcon({String? cardSubtype}) {
    if (cardSubtype != null) {
      if (cardSubtype.toLowerCase().contains('visa')) {
        return FontAwesomeIcons.ccVisa;
      }
      if (cardSubtype.toLowerCase().contains('mastercard')) {
        return FontAwesomeIcons.ccMastercard;
      }
      if (cardSubtype.toLowerCase().contains('amex')) {
        return FontAwesomeIcons.ccAmex;
      }
    }

    return FontAwesomeIcons.creditCard;
  }
}
