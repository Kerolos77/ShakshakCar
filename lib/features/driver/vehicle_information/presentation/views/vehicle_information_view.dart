import 'package:flutter/material.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/driver/vehicle_information/presentation/widgets/car_model_drop_down.dart';

class VehicleInformationView extends StatelessWidget {
  const VehicleInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).vehicleInformation,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SelectVehicleSection(),
            12.ph,
            CustomTextField(
              label: S.of(context).carNumber,
              hint: S.of(context).carNumber,
              keyType: TextInputType.number,
            ),
            12.ph,
            CustomTextField(
              label: S.of(context).carBrand,
              hint: S.of(context).carBrand,
            ),
            12.ph,
            YearsDropDown(),
            12.ph,
            CustomTextField(
              label: S.of(context).carColor,
              hint: S.of(context).carColor,
            ),
            24.ph,
            CustomButton(text: S.of(context).save),
            12.ph,
          ],
        ),
      ),
    );
  }
}

