import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/features/user/user_home/domain/entities/price_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/services_entity.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

class VehicleItemWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final ServiceDataEntity service;
  final PriceEntity price;

  // New parameters for price control
  final double? currentOffer;
  final double? minPrice;
  final double? maxPrice;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onReset;
  final ValueChanged<double>? onSliderChanged;

  const VehicleItemWidget({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.service,
    required this.price,
    this.currentOffer,
    this.minPrice,
    this.maxPrice,
    this.onIncrease,
    this.onDecrease,
    this.onReset,
    this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isPriceChanged = false;
    if (isSelected && currentOffer != null) {
      String basePriceStr = price.price.replaceAll(',', '');
      double originalPrice = double.tryParse(basePriceStr) ?? 0.0;
      // Check if current offer differs from original price significantly
      isPriceChanged = (currentOffer! - originalPrice).abs() > 0.1;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.05)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSecondary
                    : AppColors.primaryColor)
                : (Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).dividerColor.withOpacity(0.3)
                    : Theme.of(context).dividerColor.withOpacity(0.5)),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 45.w,
                    height: 45.w,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.network(
                      service.image ?? "",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.directions_car,
                          size: 28.r,
                          color: Theme.of(context)
                              .hintColor
                              .withOpacity(0.5)),
                    ),
                  ),
                  10.pw,
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name ?? "",
                          style: Styles.textStyle14Bold(context),
                        ),
                        4.ph,
                      ],
                    ),
                  ),
                  // Price (Show original if not selected)
                  if (!isSelected)
                    Text(
                      "${price.price} ${S.of(context).currency}",
                      style: Styles.textStyle14Bold(context)
                          .copyWith(color: AppColors.primaryColor),
                    ),
                ],
              ),
            ),
            if (isSelected) ...[
              Divider(
                height: 1.h,
                thickness: 1,
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildControlButton(
                          context: context,
                          icon: Icons.remove,
                          onTap: onDecrease,
                          isEnabled: (currentOffer ?? 0) > (minPrice ?? 0),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  S.of(context).yourOffer,
                                  style: Styles.textStyle10(context).copyWith(
                                      color: Theme.of(context).hintColor),
                                ),
                                if (isPriceChanged) ...[
                                  5.pw,
                                  InkWell(
                                    onTap: onReset,
                                    child: Icon(
                                      Icons.refresh,
                                      size: 14.sp,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            Text(
                              "${currentOffer?.toStringAsFixed(0) ?? price.price} ${S.of(context).currency}",
                              style: Styles.textStyle18Bold(context)
                                  .copyWith(color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                        _buildControlButton(
                          context: context,
                          icon: Icons.add,
                          onTap: onIncrease,
                          isEnabled: (currentOffer ?? 0) < (maxPrice ?? 100000),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryColor,
                        inactiveTrackColor:
                            AppColors.primaryColor.withOpacity(0.15),
                        thumbColor: AppColors.primaryColor,
                        overlayColor: AppColors.primaryColor.withOpacity(0.1),
                        trackHeight: 2.h,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 6.r),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 14.r),
                      ),
                      child: Slider(
                        value: currentOffer ?? 0,
                        min: minPrice ?? 0,
                        max: maxPrice ?? 100,
                        onChanged: onSliderChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isEnabled,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.primaryColor
              : Theme.of(context).disabledColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: isEnabled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          size: 18.sp,
        ),
      ),
    );
  }
}
