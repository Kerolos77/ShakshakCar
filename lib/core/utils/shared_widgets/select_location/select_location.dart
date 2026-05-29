import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  @override
  Widget build(BuildContext context) {
    LocationCubit cubit = LocationCubit.get(context)..getMyLocation();
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
                child: VerticalDivider(color: Theme.of(context).dividerColor)),
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
                controller: cubit.sourceController,
                isReadOnly: true,
                borderColor: cubit.isSourceSelected
                    ? AppColors.darkPurpleColor
                    : AppColors.secondaryColor,
                onTap: () {
                  setState(() {
                    cubit.isSourceSelected = true;
                  });
                  navigateTo(context, Routes.selectDestinationPage, extra: {
                    'cubit': cubit,
                  });
                },
              ),
              12.ph,
              CustomTextField(
                hint: S.of(context).dropoffLocation,
                controller: cubit.destinationController,
                isReadOnly: true,
                borderColor: !cubit.isSourceSelected
                    ? AppColors.darkPurpleColor
                    : AppColors.secondaryColor,
                onTap: () {
                  setState(() {
                    cubit.isSourceSelected = false;
                  });
                  navigateTo(context, Routes.selectDestinationPage, extra: {
                    'cubit': cubit,
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
