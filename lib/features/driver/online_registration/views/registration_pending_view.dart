import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';

import 'package:shakshak/generated/l10n.dart';

class RegistrationPendingView extends StatelessWidget {
  const RegistrationPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).onlineRegistration,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pending_actions_rounded,
              size: 100.r,
              color: Theme.of(context).primaryColor,
            ),
            40.ph,
            Text(
              S.of(context).registrationPending,
              style: Styles.textStyle20Bold(context),
              textAlign: TextAlign.center,
            ),
            16.ph,
            Text(
              S.of(context).registrationPendingDescription,
              style: Styles.textStyle16(context),
              textAlign: TextAlign.center,
            ),
            60.ph,
            CustomButton(
              text: S.of(context).goHome,
              onTap: () {
                navigateAndFinish(context, Routes.userHomeView);
              },
            ),
          ],
        ),
      ),
    );
  }
}


