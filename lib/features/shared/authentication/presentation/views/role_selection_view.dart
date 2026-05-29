import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';

import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/generated/assets.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/widgets/role_selection_button.dart';
import 'package:shakshak/features/shared/authentication/presentation/widgets/role_selection_widget.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            20.ph,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.ph,
                Center(
                  child: SvgPicture.asset(
                    Assets.svgLogin,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                Text(
                  S.of(context).loginAs,
                  style: Styles.textStyle18SemiBold(context),
                ),
                20.ph,
                const RoleSelectionWidget(),
                30.ph,
                RoleSelectionButton(),
                10.ph,
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).noAccount,
                        style: Styles.textStyle14(context).copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          navigateTo(context, Routes.registerView);
                        },
                        child: Text(
                          S.of(context).signup,
                          style: Styles.textStyle14(context).copyWith(
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16.w),
          ],
        ),
      ),
    );
  }
}


