import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';

import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/l10n.dart';

class TermsAndConditionsWidget extends StatelessWidget {
  const TermsAndConditionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: S.of(context).byTapping,
        style: Styles.textStyle16(context),
        children: [
          TextSpan(
            text: ' "${S.of(context).next}" ',
            style: Styles.textStyle16Bold(context),
          ),
          TextSpan(
            text: S.of(context).agreeTo,
            style: Styles.textStyle16SemiBold(context),
          ),
          TextSpan(
            text: S.of(context).termsAndConditions,
            style: Styles.textStyle16Bold(context).copyWith(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                navigateTo(context, Routes.termsAndConditionsView);
              },
          ),
          TextSpan(
            text: ' ${S.of(context).and} ',
            style: Styles.textStyle16(context),
          ),
          TextSpan(
            text: S.of(context).privacyPolicy,
            style: Styles.textStyle16Bold(context).copyWith(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                navigateTo(context, Routes.privacyPolicyView);
              },
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 30.w);
  }
}


