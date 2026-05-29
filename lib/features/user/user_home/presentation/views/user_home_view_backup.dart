import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/trip_storage_service.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/user/saved_places/presentation/cubit/saved_places_cubit.dart';
import 'package:shakshak/features/user/user_home/data/models/ad_model.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_states.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/active_trip_widget.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/ads_banner.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/quick_actions_section.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/user_home_header.dart';

import '../../../../../core/utils/shared_widgets/custom_cancel_dialog.dart';
import '../../../../../core/utils/shared_widgets/select_location/select_location.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/l10n.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

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
