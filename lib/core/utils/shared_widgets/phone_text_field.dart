import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/styles.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String? completeNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
          textAlign: TextAlign.start,
          controller: widget.controller,
          initialValue: widget.controller?.text,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
            FilteringTextInputFormatter.digitsOnly,
          ],
          invalidNumberMessage: S.of(context).invalidNumber,
          onChanged: (phone) {
            context.read<AuthCubit>().changeCompleteNumber(
                completeNumber: phone.completeNumber,
                countryCode: phone.countryCode);
            print(context.read<AuthCubit>().completeNumber);

            completeNumber = phone.completeNumber;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            hintText: S.of(context).mobileNumber,
            hintStyle: Styles.textStyle16Medium(context),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16.dm),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16.dm),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16.dm),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16.dm),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.secondaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16.dm),
              ),
            ),
          ),
          languageCode: Localizations.localeOf(context).languageCode,
          initialCountryCode: "EG",
          style: Styles.textStyle18SemiBold(context)
              .copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
          validator: (phone) {
            if (phone == null || phone.number.isEmpty) {
              return S.of(context).phoneRequired;
            }
            return null;
          },
        ),
      ],
    );
  }
}
