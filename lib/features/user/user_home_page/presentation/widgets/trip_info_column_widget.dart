import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/user/user_home_page/presentation/widgets/text_form_field_for_select_destination_widget.dart';
import 'package:shakshak/features/user/user_home_page/presentation/widgets/user_offer_widget.dart';

import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/user/user_home_page/data/models/cancel_ride_request_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/driver_offer.dart';
import 'package:shakshak/features/user/user_home_page/data/models/request_ride_request_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/trip_type_model.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_cubit.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_states.dart';
import 'find_driver_button.dart';
import 'from_widget.dart';
import 'list_view_of_trip_type_list.dart';
import 'my_current_location_widget.dart';
import 'travel_time_widget.dart';
import 'waiting_for_replies_and_change_offer_widget.dart';

class TripInfoColumnWidget extends StatefulWidget {
  final HomeCubit cubit;
  final List<TripTypeModel> tripTypeList;

  // final TextEditingController startAddressController;
  final TextEditingController destinationController;
  final TextEditingController offerController;
  final dynamic Function()? onLocationTap;
  final List<DriverOffer> driverOffers = [
    DriverOffer(driverName: "Driver A", price: 20),
    DriverOffer(driverName: "Driver B", price: 18),
    DriverOffer(driverName: "Driver C", price: 15),
  ];

  // final Set<Marker> markers;
  // final Map<PolylineId, Polyline> polylines;
  // final String distance;

  // final String userOffer;
  // final Function clearMarkersPolylines;

  TripInfoColumnWidget({
    super.key,
    required this.cubit,
    required this.tripTypeList,
    // required this.startAddressController,
    required this.offerController,
    // required this.markers,
    // required this.polylines,
    // required this.distance,
    // required this.clearMarkersPolylines,
    required this.destinationController,
    required this.onLocationTap,
    // required this.userOffer,
  });

  @override
  State<TripInfoColumnWidget> createState() => _TripInfoColumnWidgetState();
}

class _TripInfoColumnWidgetState extends State<TripInfoColumnWidget> {
  double time = 0.0;

  int offer = 0;

  @override
  void initState() {
    // TODO: implement initState
    // offer = int.parse(widget.userOffer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is RideRequestErrorState) {
          widget.cubit
              .cancelRideRequestByPassenger(
            cancelRideRequestBody: CancelRideRequestBody(
              rideRequestsId: CacheHelper.getData(key: "rideRequestId"),
            ),
          )
              .then((value) {
            widget.cubit.requestRide(
              requestRideRequestBody: RequestRideRequestBody(
                category: widget.cubit.selectedCategoryName,
                dropOffAddress: widget.cubit.destinationAddress,
                dropoffLatitude: widget.cubit.destinationLocation.latitude,
                dropoffLongitude: widget.cubit.destinationLocation.longitude,
                pickupAddress: widget.cubit.address,
                pickupLatitude: widget.cubit.mapLocation.latitude,
                pickupLongitude: widget.cubit.mapLocation.longitude,
                farePrice: widget.offerController.text == ""
                    ? 0.0
                    : double.parse(widget.offerController.text),
              ),
            );
          });

          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return Text(
          //       state.error,
          //     );
          //   },
          // );
        }
        if (state is RideRequestSuccessState) {
          CacheHelper.saveData(
              key: 'rideRequestId',
              value: state.rideRequestResponseBody?.data!.body!.rideRequestId!);
        }
      },
      builder: (context, state) {
        if (state is RideRequestSuccessState) {
          int currentOfferValue =
              int.tryParse(widget.offerController.text) ?? 0;
          return BlocProvider.value(
            value: widget.cubit,
            child: WaitingForRepliesAndChangeOfferWidget(
              cubit: widget.cubit,
              offerController: widget.offerController,
              currentOfferValue: currentOfferValue,
            ),
          );
          // CacheHelper.saveData(
          //     key: 'rideRequestId',
          //     value: state.rideRequestResponseBody.data!.body!
          //         .rideRequestId!)
          //     .then((value) {
          //
          //   int currentOfferValue =
          //       int.tryParse(widget.offerController.text) ?? 0;
          //
          //   // showModalBottomSheet(
          //   //   shape: RoundedRectangleBorder(
          //   //     side: const BorderSide(),
          //   //     borderRadius: BorderRadius.only(
          //   //       topRight: Radius.circular(27.r),
          //   //       topLeft: Radius.circular(27.r),
          //   //     ),
          //   //   ),
          //   //   useSafeArea: true,
          //   //   isScrollControlled: true,
          //   //   isDismissible: false,
          //   //   enableDrag: false,
          //   //   context: context,
          //   //   builder: (context) {
          //   //     int currentOfferValue =
          //   //         int.tryParse(widget.offerController.text) ?? 0;
          //   //     return BlocProvider.value(
          //   //       value: widget.cubit,
          //   //       child: WaitingForRepliesAndChangeOfferWidget(
          //   //         cubit: widget.cubit,
          //   //         offerController: widget.offerController,
          //   //         currentOfferValue: currentOfferValue,
          //   //       ),
          //   //     );
          //   //   },
          //   // );
          // });
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
// Current location button
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MyCurrentLocationWidget(
                    onPressed: widget.onLocationTap,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.46,
                padding: EdgeInsets.only(
                  top: 15.h,
                  bottom: 5.h,
                  right: 10.w,
                  left: 10.w,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(27.r),
                    topLeft: Radius.circular(27.r),
                  ),
                ),
                child: ListView(
                  children: [
                    ListViewOfTripTypeList(
                      homeCubit: widget.cubit,
                      tripTypeList: widget.tripTypeList,
                      onTripTypeSelected: (TripTypeModel selectedTripType) {
                        setState(() {
                          widget.cubit.selectedCategoryName = selectedTripType
                              .type!; // Store the selected category name
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    FromWidget(
                      address: widget.cubit.address,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormFieldForSelectDestinationWidget(
                      destinationController: widget.destinationController,
                      categoryName: widget.cubit.selectedCategoryName,
                      cubit: widget.cubit,
                      address: widget.cubit.address,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    UserOfferWidget(
                      controller: widget.offerController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    widget.cubit.destinationAddress != 'No Address Found'
                        ? TravelTimeWidget()
                        : SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DriverButton(
                          buttonText: S.of(context).findDriver,
                          onPressed: () {
                            widget.cubit.requestRide(
                              requestRideRequestBody: RequestRideRequestBody(
                                category: widget.cubit.selectedCategoryName,
                                dropOffAddress: widget.cubit.destinationAddress,
                                dropoffLatitude:
                                    widget.cubit.destinationLocation.latitude,
                                dropoffLongitude:
                                    widget.cubit.destinationLocation.longitude,
                                pickupAddress: widget.cubit.address,
                                pickupLatitude:
                                    widget.cubit.mapLocation.latitude,
                                pickupLongitude:
                                    widget.cubit.mapLocation.longitude,
                                farePrice: widget.offerController.text == ""
                                    ? 0.0
                                    : double.parse(widget.offerController.text),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // BlocConsumer<HomeCubit, HomeState>(
              //   builder: (context, state) {
              //     return SizedBox.shrink();
              //   },
              //   listener: (context, state) {
              //
              //   },
              // ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
