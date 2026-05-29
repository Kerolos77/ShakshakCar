import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/view_models/drawer_cubit/drawer_cubit.dart';

import 'package:shakshak/core/utils/shared_widgets/custom_cached_network_image.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/authentication/presentation/widgets/logout_dialog.dart';
import 'driver_drawer_list_items.dart';
import 'user_drawer_list_items.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerState>(
      builder: (context, state) {
        final cubit = context.read<DrawerCubit>();
        final selectedIndex = cubit.selectedDrawerItemIndex;
        return Drawer(
          width: 300.w,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildPremiumHeader(context),
                    10.ph,
                    CacheHelper.getData(key: AppConstant.kIsDriver) == 1
                        ? DriverDrawerListItems(
                            selectedIndex: selectedIndex, cubit: cubit)
                        : UserDrawerListItems(
                            selectedIndex: selectedIndex, cubit: cubit),
                  ],
                ),
              ),
              _buildFooter(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final profileModel = context.read<AuthCubit>().profileModel;
        final user = state is GetProfileSuccessState ? state.userModel.data : profileModel?.data;
        
        final imageUrl = user?.image;
        final userName = user?.name ?? CacheHelper.getData(key: AppConstant.kUserName) ?? 'Guest User';
        final userEmail = user?.email ?? user?.phone ?? 'Welcome to ShakShak';
        final activePackage = user?.activePackage;
        final isPremium = activePackage != null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 30.h,
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPremium 
                ? [const Color(0xFFD4AF37), AppColors.primaryColor] // Gold to Primary
                : [AppColors.primaryColor, AppColors.primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(80.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(isPremium ? 4.r : 3.r),
                    decoration: BoxDecoration(
                      color: isPremium ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: isPremium ? [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ] : null,
                    ),
                    child: Hero(
                      tag: 'profile_pic_drawer',
                      child: Container(
                        width: 85.r,
                        height: 85.r,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? CustomCachedNetworkImage(
                                imgUrl: imageUrl,
                                width: 85.r,
                                height: 85.r,
                                errorIconSize: 35.r,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.9),
                                radius: 42.5.r,
                                child: Icon(
                                  Icons.person_rounded,
                                  color: AppColors.primaryColor,
                                  size: 50.r,
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (isPremium)
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4AF37),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_rounded, color: Colors.white, size: 16.r),
                    ),
                ],
              ),
              20.ph,
              Text(
                userName,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Styles.textStyle20Bold(context).copyWith(
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              if (isPremium) ...[
                4.ph,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
                  ),
                  child: Text(
                    activePackage.name,
                    style: TextStyle(
                      color: const Color(0xFFD4AF37),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              15.ph,
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  navigateTo(context, Routes.profileView);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.white, size: 14.r),
                      8.pw,
                      Text(
                        S.of(context).profile,
                        style: Styles.textStyle12SemiBold(context).copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        children: [
          CacheHelper.getData(key: AppConstant.kToken) != null
              ? InkWell(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => LogoutDialog(),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,
                          color: AppColors.redColor, size: 22.r),
                      12.pw,
                      Text(
                        S.of(context).logout,
                        style: Styles.textStyle16Bold(context)
                            .copyWith(color: AppColors.redColor),
                      ),
                    ],
                  ),
                )
              : InkWell(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    navigateAndFinish(context, Routes.loginView);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.login_rounded,
                          color: AppColors.primaryColor, size: 22.r),
                      12.pw,
                      Text(
                        S.of(context).login,
                        style: Styles.textStyle16Bold(context)
                            .copyWith(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
          12.ph,
          Text(
            "Version 1.0.0",
            style: Styles.textStyle12(context).copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
