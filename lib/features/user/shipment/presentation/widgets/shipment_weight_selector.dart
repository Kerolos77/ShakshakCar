import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentWeightSelector extends StatelessWidget {
  final String? selectedWeight;
  final bool isWeightError;
  final ValueChanged<String> onWeightSelected;

  const ShipmentWeightSelector({
    super.key,
    required this.selectedWeight,
    required this.isWeightError,
    required this.onWeightSelected,
  });

  @override
  Widget build(BuildContext context) {
    final weights = [
      {
        'value': 'light',
        'label': S.of(context).weightLight,
        'icon': Icons.card_giftcard,
      },
      {
        'value': 'medium',
        'label': S.of(context).weightMedium,
        'icon': Icons.local_shipping,
      },
      {
        'value': 'heavy',
        'label': S.of(context).weightHeavy,
        'icon': Icons.airport_shuttle,
      },
    ];

    return Row(
      children: weights.map((w) {
        final isSelected = selectedWeight == w['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => onWeightSelected(w['value'] as String),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(
                  vertical: 12.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : (isWeightError
                          ? AppColors.redColor.withValues(alpha: 0.6)
                          : AppColors.primaryColor.withValues(alpha: 0.15)),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    w['icon'] as IconData,
                    color: isSelected ? Colors.white : AppColors.primaryColor,
                    size: 24.sp,
                  ),
                  6.ph,
                  Text(
                    w['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
