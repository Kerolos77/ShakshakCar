import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/trip_storage_service.dart';
import 'package:shakshak/features/shared/base_layout/presentation/widgets/custom_drawer.dart';
import 'package:shakshak/features/shared/notifications/presentation/manager/notification_cubit.dart';
import 'package:shakshak/features/user/saved_places/presentation/cubit/saved_places_cubit.dart';
import 'package:shakshak/features/user/user_home/data/models/ad_model.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/active_trip_widget.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/ads_banner.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/quick_actions_section.dart';

import '../../../../../core/utils/shared_widgets/custom_cancel_dialog.dart';
import '../../../../../core/utils/shared_widgets/select_location/select_location.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<UserHomeCubit>().getCaptions();
    context.read<SavedPlacesCubit>().fetchSavedPlaces();
    context.read<UserHomeCubit>().checkActiveTrip();
    context.read<UserHomeCubit>().getServices(true); // Fetch ride types
    context.read<AuthCubit>().getProfile(); // Fetch fresh user data
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return 'طاب يومك';
    } else {
      return 'مساء الخير';
    }
  }

  IconData _getIconForService(String title) {
    if (title.contains('مميز') || title.toLowerCase().contains('premium'))
      return Icons.star_rounded;
    if (title.contains('دراجة') ||
        title.contains('موتوسيكل') ||
        title.toLowerCase().contains('bike')) return Icons.two_wheeler_rounded;
    if (title.contains('عائلي') || title.toLowerCase().contains('family'))
      return Icons.airport_shuttle_rounded;
    return Icons.directions_car_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserHomeCubit, UserHomeState>(
      listener: (context, state) {
        if (state is NewRideRequestActiveTripFound) {
          // Stay on Home
        } else if (state is NewRideRequestSuccess &&
            ModalRoute.of(context)?.isCurrent == true) {
          context.read<LocationCubit>().updateFromRide(state.newRideModel);
          final preAssignStatuses = [
            'pending',
            'searching',
            'negotiating',
            'user_accept_offer',
            'payment_pending',
          ];
          if (preAssignStatuses.contains(state.newRideModel.status)) {
            navigateAndFinish(context, Routes.offersView,
                extra: OffersViewArgs(newRideData: state.newRideModel));
          } else {
            navigateAndFinish(context, Routes.driveDetailsView,
                extra: DriveDetailsViewArgs(ride: state.newRideModel));
          }
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (context.canPop()) {
            context.pop();
          } else {
            SystemNavigator.pop();
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          child: Scaffold(
            key: _scaffoldKey,
            drawer: const CustomDrawer(),
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: BlocConsumer<LocationCubit, LocationState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          16.ph,
                          // ✨ NEW INLINE HEADER (Profile & Notifications) ✨
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () =>
                                    _scaffoldKey.currentState?.openDrawer(),
                                borderRadius: BorderRadius.circular(24.r),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24.r,
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      child: Icon(Icons.person,
                                          color: Theme.of(context).primaryColor,
                                          size: 28.r),
                                    ),
                                    12.pw,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${S.of(context).welcomeBack},',
                                          style: Styles.textStyle14(context)
                                              .copyWith(
                                            color: AppColors.darkGreyColor,
                                          ),
                                        ),
                                        BlocBuilder<AuthCubit, AuthState>(
                                          builder: (context, authState) {
                                            final profile = context
                                                .read<AuthCubit>()
                                                .profileModel
                                                ?.data;
                                            final name = profile?.name ??
                                                CacheHelper.getData(
                                                    key: AppConstant
                                                        .kUserName) ??
                                                'User';
                                            return Text(
                                              name,
                                              style: Styles.textStyle18Bold(
                                                      context)
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<NotificationCubit, NotificationState>(
                                builder: (context, state) {
                                  int unreadCount = 0;
                                  if (state is NotificationLoaded) {
                                    unreadCount = state.unreadCount;
                                  } else {
                                    unreadCount = context
                                        .read<NotificationCubit>()
                                        .unreadCount;
                                  }
                                  return IconButton(
                                    onPressed: () {
                                      navigateTo(
                                          context, Routes.notificationView);
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.05),
                                      padding: EdgeInsets.all(12.r),
                                    ),
                                    icon: Badge(
                                      isLabelVisible: unreadCount > 0,
                                      label: Text(unreadCount.toString()),
                                      child: Icon(
                                        Icons.notifications_none_rounded,
                                        color: Theme.of(context).primaryColor,
                                        size: 26.r,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          BlocBuilder<UserHomeCubit, UserHomeState>(
                            buildWhen: (previous, current) =>
                                current is NewRideRequestActiveTripFound ||
                                current is CancelOrderSuccess ||
                                current is TripStatusChanged,
                            builder: (context, state) {
                              final activeTripId =
                                  TripStorageService.getActiveTripId();
                              if (activeTripId != null) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 24.h),
                                  child: ActiveTripWidget(
                                    tripId: activeTripId,
                                    activeTrip:
                                        (state is NewRideRequestActiveTripFound)
                                            ? state.activeTrip
                                            : null,
                                    onCancel: () {
                                      _showCancelConfirmationDialog(
                                          context, activeTripId);
                                    },
                                    onTap: () {
                                      context
                                          .read<UserHomeCubit>()
                                          .getRideDetails(activeTripId);
                                    },
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          BlocBuilder<UserHomeCubit, UserHomeState>(
                            buildWhen: (previous, current) =>
                                current is NewRideRequestActiveTripFound ||
                                current is CancelOrderSuccess ||
                                current is TripStatusChanged ||
                                current is ServicesSuccess ||
                                current is ServicesLoading,
                            builder: (context, state) {
                              final activeTripId =
                                  TripStorageService.getActiveTripId();
                              if (activeTripId != null) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
                                  24.ph,
                                  // ✨ HERO SEARCH CARD ✨
                                  Container(
                                    padding: EdgeInsets.all(20.r),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.08),
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.02),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.15),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.05),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${_getGreeting()}، ',
                                              style: Styles.textStyle18SemiBold(
                                                      context)
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            Text(
                                              '${CacheHelper.getData(key: AppConstant.kUserName) ?? ''} 👋',
                                              style: Styles.textStyle18Bold(
                                                      context)
                                                  .copyWith(
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        8.ph,
                                        Text(
                                          S.of(context).whereYouWantToGo,
                                          style:
                                              Styles.textStyle14Medium(context)
                                                  .copyWith(
                                            color: AppColors.darkGreyColor,
                                          ),
                                        ),
                                        20.ph,
                                        const SelectLocation(),
                                      ],
                                    ),
                                  ),

                                  // ✨ DYNAMIC RIDE TYPES GRID (FROM API) ✨
                                  24.ph,
                                  Builder(builder: (context) {
                                    final cubit = context.read<UserHomeCubit>();
                                    final services = cubit.servicesDetails;

                                    if (services.isEmpty &&
                                        state is ServicesLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    if (services.isEmpty)
                                      return const SizedBox.shrink();

                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: services.map((serviceDetail) {
                                          final title =
                                              serviceDetail.service.name ?? '';
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(left: 12.w),
                                            child: _buildRideTypeOption(
                                              context,
                                              icon: _getIconForService(title),
                                              title: title,
                                              onTap: () {
                                                // Trigger location selection or specific ride logic
                                                FocusScope.of(context)
                                                    .unfocus();
                                                navigateTo(
                                                    context,
                                                    Routes
                                                        .selectDestinationPage);
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            },
                          ),
                          24.ph,
                          const QuickActionsSection(),
                          24.ph,
                          BlocBuilder<UserHomeCubit, UserHomeState>(
                            buildWhen: (previous, current) =>
                                current is UserHomeCaptionLoading ||
                                current is UserHomeCaptionSuccess ||
                                current is UserHomeCaptionFailure,
                            builder: (context, state) {
                              List<AdModel> ads = [];
                              if (state is UserHomeCaptionSuccess) {
                                ads = state.userHomeCaptionModel.captions
                                    .map((item) {
                                  return AdModel(
                                    title:
                                        item.service?.title ?? 'Shakshak Car',
                                    subtitle: item.caption,
                                    image: item.service?.image,
                                    gradientColors: [
                                      AppColors.primaryColor,
                                      AppColors.secondaryColor,
                                    ],
                                  );
                                }).toList();
                              }

                              if (ads.isEmpty &&
                                  state is! UserHomeCaptionLoading) {
                                ads = [
                                  AdModel(
                                    title: 'خصم خاص',
                                    subtitle: 'احصل على خصم 50% لرحلتك الأولى!',
                                    gradientColors: [
                                      AppColors.primaryColor,
                                      AppColors.secondaryColor,
                                    ],
                                  ),
                                ];
                              }

                              return AdsBanner(ads: ads);
                            },
                          ),
                          40.ph,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRideTypeOption(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 28.sp,
            ),
          ),
          8.ph,
          Text(
            title,
            style: Styles.textStyle12Bold(context),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context, int orderId) {
    showCustomCancelDialog(
      context: context,
      onConfirm: () {
        context.read<UserHomeCubit>().cancelOrder(orderId: orderId);
      },
    );
  }
}

/* 
========================================================================
================= ORIGINAL OLD UI BACKUP ===============================
========================================================================

class _UserHomeViewState extends State<UserHomeView> {
  @override
  void initState() {
    super.initState();
    context.read<UserHomeCubit>().getCaptions();
    context.read<SavedPlacesCubit>().fetchSavedPlaces();
    context.read<UserHomeCubit>().checkActiveTrip();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserHomeCubit, UserHomeState>(
      listener: (context, state) {
        if (state is NewRideRequestActiveTripFound) {
          // Stay on Home and show the widget instead of auto-navigating.
        } else if (state is NewRideRequestSuccess &&
            ModalRoute.of(context)?.isCurrent == true) {
          // Sync location cubit before navigation
          context.read<LocationCubit>().updateFromRide(state.newRideModel);

          // This state can come from getRideDetails.
          // We only navigate if we are on the Home screen to avoid double-navigation if BookRide is open.
          // التوجيه بناءً على حالة الرحلة
          // الحالات اللي الرحلة لسه ما اتعيّنلهاش سواق → صفحة الأوفرات
          final preAssignStatuses = [
            'pending',
            'searching',
            'negotiating',
            'user_accept_offer',
            'payment_pending',
          ];
          if (preAssignStatuses.contains(state.newRideModel.status)) {
            navigateAndFinish(context, Routes.offersView,
                extra: OffersViewArgs(newRideData: state.newRideModel));
          } else {
            navigateAndFinish(context, Routes.driveDetailsView,
                extra: DriveDetailsViewArgs(ride: state.newRideModel));
          }
        }
      },
      child: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BaseLayoutView(
            forceDrawer: true,
            showDrawer: true,
            header: const UserHomeHeader(),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder<UserHomeCubit, UserHomeState>(
                      buildWhen: (previous, current) =>
                          current is NewRideRequestActiveTripFound ||
                          current is CancelOrderSuccess ||
                          current is TripStatusChanged,
                      builder: (context, state) {
                        final activeTripId =
                            TripStorageService.getActiveTripId();
                        if (activeTripId != null) {
                          return ActiveTripWidget(
                            tripId: activeTripId,
                            activeTrip: (state is NewRideRequestActiveTripFound)
                                ? state.activeTrip
                                : null,
                            onCancel: () {
                              _showCancelConfirmationDialog(
                                  context, activeTripId);
                            },
                            onTap: () {
                              context
                                  .read<UserHomeCubit>()
                                  .getRideDetails(activeTripId);
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<UserHomeCubit, UserHomeState>(
                      buildWhen: (previous, current) =>
                          current is NewRideRequestActiveTripFound ||
                          current is CancelOrderSuccess ||
                          current is TripStatusChanged,
                      builder: (context, state) {
                        final activeTripId =
                            TripStorageService.getActiveTripId();
                        if (activeTripId != null) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            24.ph,
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    S.of(context).whereYouWantToGo,
                                    style: Styles.textStyle18SemiBold(context),
                                  ),
                                  16.ph,
                                  const SelectLocation(),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    24.ph,
                    const QuickActionsSection(),
                    24.ph,
                    BlocBuilder<UserHomeCubit, UserHomeState>(
                      buildWhen: (previous, current) =>
                          current is UserHomeCaptionLoading ||
                          current is UserHomeCaptionSuccess ||
                          current is UserHomeCaptionFailure,
                      builder: (context, state) {
                        List<AdModel> ads = [];
                        if (state is UserHomeCaptionSuccess) {
                          ads = state.userHomeCaptionModel.captions.map((item) {
                            return AdModel(
                              title: item.service?.title ?? 'Shakshak Car',
                              subtitle: item.caption,
                              image: item.service?.image,
                              gradientColors: [
                                AppColors.primaryColor,
                                AppColors.secondaryColor,
                              ],
                            );
                          }).toList();
                        }

                        if (ads.isEmpty && state is! UserHomeCaptionLoading) {
                          // Fallback or generic ads if no captions
                          ads = [
                            AdModel(
                              title: 'Special Offer',
                              subtitle: 'Get 50% off on your first ride!',
                              gradientColors: [
                                AppColors.primaryColor,
                                AppColors.secondaryColor,
                              ],
                            ),
                          ];
                        }

                        return AdsBanner(ads: ads);
                      },
                    ),
                    24.ph,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context, int orderId) {
    showCustomCancelDialog(
      context: context,
      onConfirm: () {
        context.read<UserHomeCubit>().cancelOrder(orderId: orderId);
      },
    );
  }
}
*/
