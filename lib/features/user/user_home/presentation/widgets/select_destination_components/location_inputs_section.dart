import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';

class LocationInputsSection extends StatefulWidget {
  final LocationCubit cubit;

  const LocationInputsSection({
    super.key,
    required this.cubit,
  });

  @override
  State<LocationInputsSection> createState() => _LocationInputsSectionState();
}

class _LocationInputsSectionState extends State<LocationInputsSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              height: 24.r,
              width: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2),
              ),
            ),
            SizedBox(
                height: 50.h,
                child: VerticalDivider(
                  color: Theme.of(context).dividerColor,
                )),
            Container(
              height: 24.r,
              width: 24.r,
              padding: EdgeInsets.all(1.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onSurface,
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 2),
              ),
              child: Icon(Icons.place,
                  color: Theme.of(context).cardColor, size: 16.r),
            ),
          ],
        ),
        12.pw,
        Expanded(
          child: Column(
            children: [
              CustomTextField(
                hint: S.of(context).pickupLocation,
                controller: widget.cubit.sourceController,
                borderColor: widget.cubit.isSourceSelected
                    ? AppColors.darkPurpleColor
                    : AppColors.secondaryColor,
                onTap: () {
                  setState(() {
                    widget.cubit.isSourceSelected = true;
                  });
                },
                onchange: (value) {
                  widget.cubit.clearPlace(isSource: true);
                  widget.cubit.getPlacesSuggestions(value!);
                },
              ),
              12.ph,
              CustomTextField(
                hint: S.of(context).dropoffLocation,
                controller: widget.cubit.destinationController,
                borderColor: !widget.cubit.isSourceSelected
                    ? AppColors.darkPurpleColor
                    : AppColors.secondaryColor,
                onTap: () {
                  setState(() {
                    widget.cubit.isSourceSelected = false;
                  });
                },
                onchange: (value) {
                  widget.cubit.clearPlace(isSource: false);
                  widget.cubit.getPlacesSuggestions(value!);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
