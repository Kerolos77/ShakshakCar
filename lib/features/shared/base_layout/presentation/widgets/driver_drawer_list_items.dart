import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/features/shared/base_layout/presentation/view_models/drawer_cubit/drawer_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

import 'custom_drawer_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/driver/home/presentation/view_models/driver_home_cubit.dart'
    as shakshak_driver_home_cubit;
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/services/user_storage_service.dart';

class DriverDrawerListItems extends StatelessWidget {
  const DriverDrawerListItems({
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
        _buildSectionLabel(context, S.of(context).driverServices),
        if (UserStorageService.getUser()?.gender == 'female')
          BlocBuilder<shakshak_driver_home_cubit.DriverHomeCubit,
              shakshak_driver_home_cubit.DriverHomeState>(
            builder: (context, state) {
              final driverCubit =
                  context.read<shakshak_driver_home_cubit.DriverHomeCubit>();
              return SwitchListTile(
                title: Text(
                  S.of(context).femaleOnlyRequests,
                  style: Styles.textStyle14SemiBold(context),
                ),
                subtitle: Text(
                  S.of(context).femaleOnlyRequestsSub,
                  style: Styles.textStyle12(context)
                      .copyWith(color: Theme.of(context).hintColor),
                ),
                value: driverCubit.acceptsFemaleOnly,
                activeColor: Colors.pinkAccent,
                secondary:
                    Icon(Icons.female, color: Colors.pinkAccent, size: 24.sp),
                onChanged: (value) {
                  driverCubit.toggleAcceptsFemaleOnly(value);
                },
              );
            },
          ),
        CustomDrawerItem(
          title: S.of(context).rideRequests,
          icon: Icons.hail_rounded,
          isSelected: selectedIndex == 0,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(0);
            navigateAndReplacement(context, Routes.driverHomeView);
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
          isSelected: selectedIndex == 2,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(2);
            navigateTo(context, Routes.walletView);
          },
        ),
        CustomDrawerItem(
          title: S.of(context).earnings,
          icon: Icons.insights_rounded,
          isSelected: selectedIndex == 3,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            navigateTo(context, Routes.driverEarningsView);
          },
        ),
        CustomDrawerItem(
          title: S.of(context).packagesStore,
          icon: Icons.store_mall_directory_rounded,
          isSelected: false,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            navigateTo(context, Routes.driverStoreView);
          },
        ),
        CustomDrawerItem(
          title: S.of(context).settings,
          icon: Icons.settings_suggest_rounded,
          isSelected: selectedIndex == 7,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(7);
            navigateTo(context, Routes.settingsView);
          },
        ),
        16.ph,
        _buildSectionLabel(context, S.of(context).vehicleAndRegistration),
        CustomDrawerItem(
          title: S.of(context).vehicleInformation,
          icon: Icons.directions_car_filled_rounded,
          isSelected: selectedIndex == 5,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(5);
            navigateTo(context, Routes.vehicleInformationView);
          },
        ),
        CustomDrawerItem(
          title: S.of(context).onlineRegistration,
          icon: Icons.fact_check_rounded,
          isSelected: selectedIndex == 6,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(6);
            navigateTo(context, Routes.driverOnlineRegistrationView);
          },
        ),
        16.ph,
        _buildSectionLabel(context, S.of(context).support),
        CustomDrawerItem(
          title: S.of(context).help,
          icon: Icons.quiz_rounded,
          isSelected: selectedIndex == 8,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            cubit.changeSelectedDrawerItem(8);
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
