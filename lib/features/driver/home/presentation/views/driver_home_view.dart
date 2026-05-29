import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/background_location_service.dart';
import 'package:shakshak/core/services/location_service.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/driver/home/presentation/view_models/driver_home_cubit.dart';
import 'package:shakshak/features/driver/home/presentation/widgets/driver_home_map.dart';
import 'package:shakshak/features/driver/home/presentation/widgets/set_destination_dialog.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_cubit.dart';
import 'package:shakshak/features/driver/new_rides/presentation/view_model/ride_state.dart';
import 'package:shakshak/features/driver/new_rides/presentation/widgets/online_offline_toggle_button.dart';
import 'package:shakshak/features/driver/outstation/presentation/widgets/driver_rides_list_item.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/base_layout/presentation/widgets/custom_drawer.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_cubit.dart';
import 'package:shakshak/features/shared/shop/presentation/view_models/shop_state.dart';
import 'package:shakshak/features/shared/shop/presentation/widgets/subscription_countdown_timer.dart';
import 'package:shakshak/generated/l10n.dart';

class DriverHomeView extends StatefulWidget {
  const DriverHomeView({super.key});

  @override
  State<DriverHomeView> createState() => _DriverHomeViewState();
}

class _DriverHomeViewState extends State<DriverHomeView> {
  final GlobalKey _mapKey = GlobalKey();
  bool _isHidden = false;
  bool _hasUnseenRides = false;
  int _lastRideCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit(
            getPackagesUseCase: sl(),
            buyPackageUseCase: sl(),
            getSubscriptionStatusUseCase: sl(),
          )..getSubscriptionStatus(),
        ),
      ],
      child: MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is GetProfileSuccessState) {
              final isOnline = state.userModel.data?.isOnline == 1;
              context.read<DriverHomeCubit>().updateOnlineStatus(isOnline);

              // Start tracking if already online from backend
              if (isOnline) {
                sl<LocationService>().startTracking(highAccuracy: true);
                BackgroundLocationService().startService();
              }
            }
          },
        ),
        BlocListener<RideCubit, RideState>(
          listener: (context, state) {
            if (_isHidden && state.rides.length > _lastRideCount) {
              setState(() => _hasUnseenRides = true);
            }
            _lastRideCount = state.rides.length;
          },
        ),
      ],
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: Stack(
          children: [
            Positioned.fill(
              child: DriverHomeMap(
                key: _mapKey,
                onTap: () {
                  if (!_isHidden) {
                    setState(() {
                      _isHidden = true;
                    });
                  }
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 3.0),
                      child: Container(
                        height: MediaQuery.of(context).padding.top,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.5)
                            : Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),

                  // الزراير تحت الـ status bar

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // زرار فتح الـ Drawer
                        Builder(
                          builder: (context) => _FloatingIconButton(
                            icon: Icons.menu_rounded,
                            onTap: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),

                        // زرار الأونلاين / أوفلاين
                        const OnlineOfflineToggleButton(),
                      ],
                    ),
                  ),

                  // شريط الأرباح السريع
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: const _FloatingEarningsWidget(),
                  ),

                  // رسالة الحظر للكاش
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final profile =
                          context.read<AuthCubit>().profileModel?.data;
                      final restrictionSecs =
                          profile?.cashRestrictionSecondsRemaining ?? 0;
                      if (restrictionSecs > 0) {
                        final minutes = (restrictionSecs / 60).ceil();
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.redColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.white, size: 24.r),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "أنت محظور مؤقتاً من طلبات الكاش بسبب الرفض المتكرر. المتبقي: $minutes دقيقة تقريباً",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            // Rides Bottom Sheet with animation
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              bottom: _isHidden ? -0.45.sh : 0,
              left: 0,
              right: 0,
              height: 0.88.sh,
              child: const _RidesBottomSheet(),
            ),

            // Visibility Toggle Button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              bottom: _isHidden ? 30.h : -100.h,
              right: 20.w,
              child: _VisibilityToggleButton(
                isHidden: true,
                hasNew: _hasUnseenRides,
                onTap: () {
                  setState(() {
                    _isHidden = false;
                    _hasUnseenRides = false;
                  });
                },
              ),
            ),

            // زر التوجيه للمنزل
            Positioned(
              bottom: _isHidden ? 30.h : 0.44.sh,
              left: 20.w,
              child: const _GoHomeButton(),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon,
            color: Theme.of(context).colorScheme.onSurface, size: 22.r),
      ),
    );
  }
}

class _FloatingEarningsWidget extends StatelessWidget {
  const _FloatingEarningsWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final profile = context.read<AuthCubit>().profileModel?.data;
          final points = profile?.rewardPoints ?? 0;
          return BlocBuilder<ShopCubit, ShopState>(
            builder: (context, shopState) {
              dynamic subscription;
              String? packageName;
              DateTime? expiryDate;

              if (shopState is ShopLoaded && shopState.subscriptionDetails != null) {
                subscription = shopState.subscriptionDetails;
                packageName = subscription.package.name;
                expiryDate = DateTime.tryParse(subscription.expiresAt);
              } else if (profile?.activePackage != null) {
                subscription = profile!.activePackage;
                packageName = subscription.name;
                
                String? rawDate = subscription.expiresAt;
                if (rawDate != null) {
                  String dateStr = rawDate.trim();
                  if (dateStr.contains(' ') && !dateStr.contains('T')) {
                    dateStr = dateStr.replaceAll(' ', 'T');
                  }
                  expiryDate = DateTime.tryParse(dateStr);
                }
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_rounded,
                      color: AppColors.primaryColor, size: 20.r),
                  SizedBox(width: 6.w),
                  Text(
                    "0 ج.م",
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  if (points > 0 || packageName != null) ...[
                    SizedBox(width: 12.w),
                    VerticalDivider(width: 1, indent: 4.h, endIndent: 4.h),
                    SizedBox(width: 12.w),
                  ],
                  if (packageName != null) ...[
                    GestureDetector(
                      onTap: () => navigateTo(context, Routes.profileView),
                      child: Row(
                        children: [
                          Icon(Icons.workspace_premium_rounded,
                              color: const Color(0xFFD4AF37), size: 20.r),
                          SizedBox(width: 6.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                packageName,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD4AF37)),
                              ),
                              if (expiryDate != null)
                                SubscriptionCountdownTimer(
                                  expiresAt: expiryDate,
                                  showLabel: false,
                                  textStyle: TextStyle(fontSize: 10.sp),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (points > 0) ...[
                      SizedBox(width: 12.w),
                      VerticalDivider(width: 1, indent: 4.h, endIndent: 4.h),
                      SizedBox(width: 12.w),
                    ],
                  ],
                  if (points > 0)
                    GestureDetector(
                      onTap: () => navigateTo(context, Routes.pointsView),
                      child: Row(
                        children: [
                          Icon(Icons.stars_rounded,
                              color: Colors.orange, size: 20.r),
                          SizedBox(width: 6.w),
                          Text(
                            points.toString(),
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _GoHomeButton extends StatelessWidget {
  const _GoHomeButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => BlocProvider<DriverHomeCubit>.value(
            value: context.read<DriverHomeCubit>(),
            child: const SetDestinationDialog(),
          ),
        );
      },
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.home_work_outlined,
          color: AppColors.primaryColor,
          size: 22.r,
        ),
      ),
    );
  }
}

class _VisibilityToggleButton extends StatelessWidget {
  final bool isHidden;
  final bool hasNew;
  final VoidCallback onTap;

  const _VisibilityToggleButton({
    required this.isHidden,
    required this.hasNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: hasNew ? AppColors.redColor : AppColors.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (hasNew ? AppColors.redColor : AppColors.primaryColor)
                      .withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.white,
              size: 28.r,
            ),
          ),
          if (hasNew)
            Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.redColor,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.redColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "يوجد رحلة جديدة!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RidesBottomSheet extends StatelessWidget {
  const _RidesBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.42,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.42, 0.88],
      builder: (_, scrollController) {
        return _SheetContent(scrollController: scrollController);
      },
    );
  }
}

class _SheetContent extends StatelessWidget {
  final ScrollController scrollController;

  const _SheetContent({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideCubit, RideState>(
      listenWhen: (prev, curr) => prev.rides.length != curr.rides.length,
      listener: (context, state) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Handle
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // ── Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w)
                    .copyWith(bottom: 8.h),
                child: Row(
                  children: [
                    Text(
                      S.of(context).rides,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    if (state.rides.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${state.rides.length}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── القائمة أو الـ empty state
              Expanded(
                child: state.rides.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_car_outlined,
                                size: 56.r,
                                color: Theme.of(context).dividerColor),
                            SizedBox(height: 12.h),
                            Text(
                              'لا توجد رحلات متاحة حالياً',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 8.h,
                          bottom: 32.h,
                          left: 16.w,
                          right: 16.w,
                        ),
                        itemCount: state.rides.length,
                        itemBuilder: (context, index) {
                          final ride = state.rides[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: DriverRidesListItem(
                              key: ValueKey(ride.id),
                              isOutstation: ride.parcelWeight != null,
                              isNew: state.newRideIds.contains(ride.id),
                              ride: ride,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
