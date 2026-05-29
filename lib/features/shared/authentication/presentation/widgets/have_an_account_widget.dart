import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/styles.dart';

import 'package:shakshak/generated/l10n.dart';

class HaveAnAccountWidget extends StatelessWidget {
  const HaveAnAccountWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).iHaveMyOwnAccount,
            style: Styles.textStyle14(context).copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          TextButton(
            onPressed: () {
              navigateAndFinish(context, Routes.loginView);
            },
            child: Text(
              S.of(context).login,
              style: Styles.textStyle14(context).copyWith(
                color: AppColors.darkGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


