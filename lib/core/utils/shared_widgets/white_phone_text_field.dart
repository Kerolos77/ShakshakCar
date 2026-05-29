/*
import 'package:enjaz/core/extentions/glopal_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shakshak/generated/assets.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/utils/validations.dart';
import 'custom_text_field.dart';

class WhitePhoneTextField extends StatefulWidget {
  const WhitePhoneTextField({
    super.key,
    required this.phoneController,
  });

  final TextEditingController phoneController;

  @override
  State<WhitePhoneTextField> createState() => _WhitePhoneTextFieldState();
}

class _WhitePhoneTextFieldState extends State<WhitePhoneTextField> {
  final TextEditingController countryController =
      TextEditingController(text: 'ðŸ‡¸ðŸ‡¦ +966');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              Assets.svgArrowRight3,
              width: 14.w,
            ),
            4.pw,
            Text(
              'Phone Number:',
              style: Styles.textStyle12.copyWith(
                color: AppColors.secondaryColor.withOpacity(0.54),
              ),
            ),
          ],
        ),
        8.ph,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CustomTextFieldWhite(
                isReadOnly: true,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                // suffix: Icon(
                //   Icons.keyboard_arrow_down,
                //   color: AppColors.grey4Color,
                //   size: 16.r,
                // ),
                onTap: () {
                  */
/*showCountryPicker(
                    context: context,
                    countryListTheme: CountryListThemeData(
                      flagSize: 25.r,
                      backgroundColor: Colors.white,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.blueGrey),
                      bottomSheetHeight: 500.h,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0.r),
                        topRight: Radius.circular(20.0.r),
                      ),
                      inputDecoration: InputDecoration(
                        labelText: 'search label',
                        hintText: 'search hint',
                        prefix: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: SvgPicture.asset(Assets.svgPhone),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    onSelect: (Country country) {
                      setState(() {
                        countryController.text =
                            '${country.flagEmoji} +${country.phoneCode}';
                        print(countryController.text);
                      });
                    },
                  );*/ /*

                },
                hint: 'country',
                controller: countryController,
              ),
            ),
            10.pw,
            Expanded(
              flex: 5,
              child: CustomTextFieldWhite(
                controller: widget.phoneController,
                keyType: TextInputType.phone,
                hint: '5xxxxxxxx',
                suffix: Icon(
                  Icons.edit,
                  size: 20.r,
                  color: AppColors.grey4Color,
                ),
                validator: Validation.validatePhone(context),
                // Localized string
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
*/

