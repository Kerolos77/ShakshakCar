import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentTermsCheckbox extends StatelessWidget {
  final bool acceptedTerms;
  final bool isTermsError;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTapTerms;

  const ShipmentTermsCheckbox({
    super.key,
    required this.acceptedTerms,
    required this.isTermsError,
    required this.onChanged,
    required this.onTapTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: acceptedTerms,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTapTerms,
            child: Text(
              '${S.of(context).agreeToTerms}${S.of(context).termsLink}',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: isTermsError ? AppColors.redColor : AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
