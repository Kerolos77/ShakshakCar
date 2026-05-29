import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/utils/shared_widgets/select_location/select_location.dart';

class OutStationView extends StatefulWidget {
  const OutStationView({super.key});

  @override
  State<OutStationView> createState() => _OutStationViewState();
}

class _OutStationViewState extends State<OutStationView> {
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).outstation,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SelectLocation(),
            12.ph,
            // const SelectVehicleSection(),
            12.ph,
            CustomTextField(
              hint: S.of(context).when,
              controller: dateController,
              isReadOnly: true,
              onTap: () {
                // _showDateTimePicker(context);
                _showDatePicker();
              },
            ),
            12.ph,
            CustomTextField(
              hint: S.of(context).numberOfPassengers,
              keyType: TextInputType.number,
            ),
            12.ph,
            // CustomTextField(
            //   hint: S.of(context).enterOfferRate,
            //   keyType: TextInputType.number,
            // ),
            12.ph,
            // CustomDropDown(
            //   items: [
            //     S.of(context).cash,
            //     S.of(context).wallet,
            //   ],
            //   onChange: (p0) {},
            //   hint: S.of(context).selectPaymentMethod,
            // ),
            20.ph,
            // CustomButton(text: S.of(context).placeRide),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() {
    // final isArabic = S.maybeOf(context) == 'ar';
    final isArabic = Intl.getCurrentLocale().startsWith('ar');

    print(Intl.getCurrentLocale());
    print(isArabic ? 'ar' : 'en');
    DatePicker.showDateTimePicker(
      context,
      theme: DatePickerTheme(
        doneStyle: TextStyle(color: AppColors.primaryColor, fontSize: 18),
        cancelStyle: TextStyle(color: AppColors.greyColor, fontSize: 16),
      ),
      minTime: DateTime.now(),
      maxTime: DateTime(2030, 12, 31),
      currentTime: DateTime.now().add(const Duration(seconds: 1)),
      showTitleActions: true,
      locale: isArabic ? LocaleType.ar : LocaleType.en,
      onConfirm: (val) {
        final formatted = DateFormat('a  h : mm , EEE MMM d').format(val);
        setState(() => dateController.text = formatted);
      },
    );
  }
}



