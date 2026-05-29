import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/user/user_home/data/models/services_deteles_model.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/user/user_home/data/models/price_model.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/vehicle_item_widget.dart';

class RideServicesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<ServicesDetailsModel> services;
  final int selectedServiceIndex;
  final Function(int, String) onServiceSelected;
  final double currentOffer;
  final double minPriceLimit;
  final double maxPriceLimit;
  final VoidCallback onIncreasePrice;
  final VoidCallback onDecreasePrice;
  final ValueChanged<double> onSliderChanged;
  final Function(String) onResetPrice;
  final bool isInCity;

  const RideServicesList({
    super.key,
    required this.scrollController,
    required this.services,
    required this.selectedServiceIndex,
    required this.onServiceSelected,
    required this.currentOffer,
    required this.minPriceLimit,
    required this.maxPriceLimit,
    required this.onIncreasePrice,
    required this.onDecreasePrice,
    required this.onSliderChanged,
    required this.onResetPrice,
    required this.isInCity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Text(
                    isInCity ? S.of(context).city : S.of(context).outstation,
                    style: Styles.textStyle12Bold(context)
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ),
                Expanded(
                  child: Center(child: SizedBox.shrink()),
                ),
              ],
            ),
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            itemCount: services.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final serviceDetails = services[index];
              final bool isSelected = selectedServiceIndex == index;

              return VehicleItemWidget(
                service: serviceDetails.service!,
                price: serviceDetails.price ??
                    PriceModel(
                      price: "0",
                      km: 0,
                      min: "0",
                    ),
                isSelected: isSelected,
                currentOffer: isSelected ? currentOffer : null,
                minPrice: isSelected ? minPriceLimit : null,
                maxPrice: isSelected ? maxPriceLimit : null,
                onIncrease: isSelected ? onIncreasePrice : null,
                onDecrease: isSelected ? onDecreasePrice : null,
                onReset: isSelected
                    ? () => onResetPrice(serviceDetails.price?.price ?? "0")
                    : null,
                onSliderChanged: isSelected ? onSliderChanged : null,
                onTap: () {
                  onServiceSelected(index, serviceDetails.price?.price ?? "0");
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
