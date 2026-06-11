import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/features/shared/base_layout/presentation/view_models/drawer_cubit/drawer_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'custom_drawer_item.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';

class UserDrawerListItems extends StatelessWidget {
  const UserDrawerListItems({
    super.key,
    required this.selectedIndex,
    required this.cubit,
  });

  final int selectedIndex;
  final DrawerCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(context, S.of(context).services),
        CustomDrawerItem(
          title: S.of(context).home,
          icon: Icons.home_rounded,
          isSelected: selectedIndex == 0,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(0);
            navigateAndReplacement(context, Routes.userHomeView);
          },
        ),
        CustomDrawerItem(
          title: S.of(context).rides,
          icon: Icons.history_rounded,
          isSelected: selectedIndex == 2,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(2);
            navigateTo(context, Routes.ridesView);
          },
        ),
        16.ph,
        _buildSectionLabel(context, S.of(context).accountAndWallet),
        CustomDrawerItem(
          title: S.of(context).myWallet,
          icon: Icons.account_balance_wallet_rounded,
          isSelected: selectedIndex == 4,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(4);
            navigateTo(context, Routes.walletView);
          },
        ),
        CustomDrawerItem(
          title: S.of(context).notifications,
          icon: Icons.notifications_active_rounded,
          isSelected: selectedIndex == 10,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(10);
            navigateTo(context, Routes.notificationView);
          },
        ),
        CustomDrawerItem(
          title: "متجر الباقات",
          icon: Icons.store_mall_directory_rounded,
          isSelected: false,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            navigateTo(context, Routes.userStoreView);
          },
        ),
        CustomDrawerItem(
          title: S.of(context).settings,
          icon: Icons.settings_suggest_rounded,
          isSelected: selectedIndex == 5,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(5);
            navigateTo(context, Routes.settingsView);
          },
        ),
        CustomDrawerItem(
          title: "توثيق الحساب (الهوية)",
          icon: Icons.verified_user_rounded,
          isSelected: selectedIndex == 15,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(15);
            navigateTo(context, Routes.userIdentityVerificationView);
          },
        ),
        16.ph,
        _buildSectionLabel(context, S.of(context).workWithUs),
        CustomDrawerItem(
          title: S.of(context).onlineRegistration,
          icon: Icons.card_membership_rounded,
          isSelected: selectedIndex == 9,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(9);
            navigateTo(context, Routes.driverOnlineRegistrationView);
          },
        ),
        16.ph,
        _buildSectionLabel(context, S.of(context).support),
        CustomDrawerItem(
          title: S.of(context).help,
          icon: Icons.quiz_rounded,
          isSelected: selectedIndex == 7,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(7);
            navigateTo(context, Routes.helpCenterView);
          },
        ),
      ],
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 8.h),
      child: Text(
        label.toUpperCase(),
        style: Styles.textStyle12Bold(context).copyWith(
          color: Theme.of(context).hintColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
