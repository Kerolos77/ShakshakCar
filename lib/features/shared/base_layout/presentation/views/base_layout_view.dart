import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_app_bar.dart';
import 'package:shakshak/features/shared/base_layout/presentation/widgets/custom_drawer.dart';

class BaseLayoutView extends StatelessWidget {
  const BaseLayoutView({
    super.key,
    this.header,
    this.body,
    this.title,
    this.horizontalPadding = 16,
    this.topPadding = 0,
    this.bottomSheet,
    this.forceDrawer = false,
    this.showDrawer = false,
    this.showAppBar = true,
    this.trailing,
  });

  final Widget? header;
  final Widget? body;
  final Widget? bottomSheet;
  final Widget? trailing;
  final String? title;
  final bool forceDrawer;
  final bool showDrawer;
  final bool showAppBar;
  final double horizontalPadding, topPadding;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          try {
            final currentRoute = GoRouterState.of(context).uri.toString();
            final isDriver =
                CacheHelper.getData(key: AppConstant.kIsDriver) == 1;
            final homeRoute =
                isDriver ? Routes.driverHomeView : Routes.userHomeView;

            if (currentRoute == homeRoute ||
                currentRoute == Routes.loginView ||
                currentRoute == Routes.onBoardingView ||
                currentRoute == Routes.splashView ||
                currentRoute == Routes.roleSelectionView) {
              SystemNavigator.pop();
            } else {
              context.go(homeRoute);
            }
          } catch (e) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        drawer: showDrawer ? CustomDrawer() : null,
        bottomSheet: bottomSheet,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: Theme.of(context).primaryColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showAppBar) ...[
                  40.ph,
                  CustomAppBar(
                    title: title,
                    forceDrawer: forceDrawer,
                    trailing: trailing,
                  ),
                ],
                header ?? SizedBox.shrink(),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.only(),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            20.r,
                          ),
                        )),
                    child: body,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
