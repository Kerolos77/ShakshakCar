import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/driver/outstation/presentation/widgets/user_info_sheet.dart';
import 'package:shakshak/features/shared/payment/presentation/widgets/saved_cards_bottom_sheet.dart';
import 'package:shakshak/features/shared/review/presentation/views/user_reviews_view.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_user.dart';
import 'package:shakshak/features/user/user_home/data/models/trip_offer_model.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_state.dart';
import 'package:shakshak/generated/l10n.dart';

class OfferItem extends StatefulWidget {
  final TripOfferModel offer;
  final NewRideDataEntity originalRideData;
  final int timerDurationSeconds;

  const OfferItem({
    super.key,
    required this.offer,
    required this.originalRideData,
    this.timerDurationSeconds = 30, // Default 30 seconds
  });

  @override
  State<OfferItem> createState() => _OfferItemState();
}

class _OfferItemState extends State<OfferItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timerDurationSeconds),
    );

    _controller.reverse(from: 1.0);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _autoDeny();
      }
    });
  }

  void _autoDeny() {
    if (mounted) {
      context.read<UserHomeCubit>().denyOffer(
            offerId: widget.offer.id,
          );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserHomeCubit, UserHomeState>(
      listener: (context, state) {
        if (state is AcceptOfferSuccess && state.offerId == widget.offer.id) {
          navigateTo(context, Routes.driveDetailsView,
              extra: DriveDetailsViewArgs(
                ride: NewRideData(
                  id: state.acceptOfferModel.data?.id ?? widget.offer.id,
                  amount: widget.offer.offerDriver.toDouble(),
                  finalRate: widget.offer.offerDriver.toDouble(),
                  distance: widget.originalRideData.distance,
                  distanceType: widget.originalRideData.distanceType,
                  sourceLat: widget.originalRideData.sourceLat,
                  sourceLong: widget.originalRideData.sourceLong,
                  destinationLat: widget.originalRideData.destinationLat,
                  destinationLong: widget.originalRideData.destinationLong,
                  sourceAddress: widget.originalRideData.sourceAddress,
                  destinationAddress:
                      widget.originalRideData.destinationAddress,
                  status: 'accepted',
                  user: NewRideUser(
                    id: widget.offer.driverId,
                    name: widget.offer.driverName.isEmpty
                        ? 'Driver ${widget.offer.driverId}'
                        : widget.offer.driverName,
                    phone: widget.offer.driverPhone,
                    image: widget.offer.driverImage,
                    countryId: '',
                    email: '',
                    walletAmount: 0,
                    pendingWallet: 0,
                    isDriver: true,
                    isOnline: true,
                    serviceId: 0,
                  ),
                  isOffer: true,
                  createdAt: DateTime.now(),
                  carBrand: widget.offer.carBrand,
                  carModel: widget.offer.carModel,
                  carColor: widget.offer.carColor,
                  carPlate: widget.offer.carNumber,
                  whenDate: null,
                  interCity: false,
                  userServiceId: 0,
                  paid: false,
                  paymentType: 'cash',
                  numberOfPassenger: 1,
                  serviceType: widget.originalRideData.serviceType,
                  reviewsCount: 0,
                  hasReview: false,
                ),
              ));
        } else if (state is AcceptOfferPaymentRequired &&
            state.offerId == widget.offer.id) {
          // Open In-App WebView Payment Screen
          navigateTo(
            context,
            Routes.ridePaymentWebView,
            extra: RidePaymentWebViewArgs(
              checkoutUrl: state.checkoutUrl,
              orderId: widget.originalRideData.id,
            ),
          );
        } else if (state is AcceptOfferFailure &&
            state.offerId == widget.offer.id) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is DenyOfferFailure &&
            state.offerId == widget.offer.id) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // فتح كارت بيانات السائق
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => UserInfoSheet(
                              user: NewRideUser(
                                id: widget.offer.driverId,
                                name: widget.offer.driverName.isEmpty
                                    ? 'Driver ${widget.offer.driverId}'
                                    : widget.offer.driverName,
                                phone: widget.offer.driverPhone,
                                image: widget.offer.driverImage,
                                countryId: '',
                                email: '',
                                walletAmount: 0,
                                pendingWallet: 0,
                                isDriver: true,
                                isOnline: true,
                                serviceId: 0,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.primaryColor, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 28.r,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            backgroundImage: widget.offer.driverImage.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    widget.offer.driverImage)
                                : null,
                            child: widget.offer.driverImage.isEmpty
                                ? Icon(Icons.person,
                                    size: 30.r,
                                    color:
                                        Theme.of(context).colorScheme.onSurface)
                                : null,
                          ),
                        ),
                      ),
                      12.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.offer.driverName.isEmpty
                                  ? 'Driver ${widget.offer.driverId}'
                                  : widget.offer.driverName,
                              style: Styles.textStyle18Bold(context),
                            ),
                            4.ph,
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => UserReviewsView(
                                    userId: widget.offer.driverId,
                                    userName: widget.offer.driverName,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 18.r),
                                  4.pw,
                                  Text(
                                    widget.offer.offerRate.toString(),
                                    style: Styles.textStyle14SemiBold(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${widget.offer.offerDriver} ${S.of(context).currency}',
                          style: Styles.textStyle18Bold(context).copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.ph,
                  // Car Info Section
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCarDetail(
                          context,
                          Icons.directions_car_filled_rounded,
                          '${widget.offer.carBrand} ${widget.offer.carModel}',
                          S.of(context).car,
                        ),
                        _buildCarDetail(
                          context,
                          Icons.tag_rounded,
                          widget.offer.carNumber,
                          S.of(context).carNumber,
                        ),
                        _buildCarDetail(
                          context,
                          Icons.palette_rounded,
                          widget.offer.carColor,
                          S.of(context).carColor,
                        ),
                      ],
                    ),
                  ),
                  20.ph,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: S.of(context).accept,
                          height: 50.h,
                          borderRadius: 14.r,
                          onTap: () {
                            if (widget.originalRideData.paymentType == 'visa' ||
                                widget.originalRideData.paymentType == 'card') {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => SavedCardsBottomSheet(
                                  amount: widget.offer.offerDriver.toDouble(),
                                  orderId: widget.originalRideData.id,
                                  onSuccess: () {
                                    context.read<UserHomeCubit>().acceptOffer(
                                          offerId: widget.offer.id,
                                          driverId: widget.offer.driverId,
                                        );
                                  },
                                ),
                              );
                            } else {
                              context.read<UserHomeCubit>().acceptOffer(
                                    offerId: widget.offer.id,
                                    driverId: widget.offer.driverId,
                                  );
                            }
                          },
                        ),
                      ),
                      12.pw,
                      Expanded(
                        child: CustomButton(
                          text: S.of(context).reject,
                          height: 50.h,
                          borderRadius: 14.r,
                          buttonColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          textColor: Colors.red,
                          onTap: () {
                            context.read<UserHomeCubit>().denyOffer(
                                  offerId: widget.offer.id,
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Precise Progress Bar
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _controller.value,
                  minHeight: 4.h,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _controller.value > 0.8
                        ? Colors.red
                        : AppColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarDetail(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon,
            size: 20.r, color: AppColors.primaryColor.withOpacity(0.7)),
        6.ph,
        Text(value, style: Styles.textStyle12Bold(context)),
        2.ph,
        Text(
          label,
          style: Styles.textStyle10SemiBold(context).copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6)),
        ),
      ],
    );
  }
}
