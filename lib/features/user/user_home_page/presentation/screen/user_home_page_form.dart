import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shakshak/features/shared/base_layout/presentation/widgets/custom_drawer.dart';
import 'package:shakshak/features/user/user_home_page/data/models/driver_offer.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_cubit.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_states.dart';
import 'package:shakshak/features/user/user_home_page/presentation/widgets/drawer_button.dart';
import 'package:shakshak/features/user/user_home_page/presentation/widgets/driver_offer_list.dart';
import 'package:shakshak/features/user/user_home_page/presentation/widgets/marker_of_user_on_map_widget.dart';
import 'package:shakshak/features/user/user_home_page/presentation/widgets/my_map_widget.dart';
import 'package:shakshak/features/user/user_home_page/presentation/widgets/trip_info_column_widget.dart';
import 'package:shakshak/generated/l10n.dart';

class UserHomePageForm extends StatefulWidget {
  const UserHomePageForm({super.key});

  @override
  State<UserHomePageForm> createState() => _UserHomePageFormState();
}

class _UserHomePageFormState extends State<UserHomePageForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _bottomSheetController;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController offerController = TextEditingController();

  GoogleMapController? mapController; // ✅ Null safe
  bool locationButtonFlag = false;
  int currentOfferIndex = 0;

  /// ثابت يحدد ارتفاع الماركر من منتصف الشاشة
  final double markerOffset = 100.h;
  final double markerHeight = 80.h;

  List<DriverOffer> driverOffers = [];

  late HomeCubit cubit;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onCameraIdle() async {
    locationButtonFlag = false;

    if (mapController == null) {
      print("⚠️ mapController لم يجهز بعد");
      return;
    }

    final size = MediaQuery.of(context).size;
    final Offset screenPoint = Offset(
      size.width / 2,
      (size.height / 2) - markerOffset,
    );
    print("📍 إحداثيات الشاشة: ${screenPoint.dx}, ${screenPoint.dy}");
    LatLng latLng = await mapController!.getLatLng(ScreenCoordinate(
      x: screenPoint.dx.round(),
      y: screenPoint.dy.round(),
    ));

    cubit.mapLocation = latLng;

    print(
        "✅ إحداثيات النقطة تحت الماركر: ${latLng.latitude}, ${latLng.longitude}");

    // ✅ إظهار SnackBar
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       "📍 Latitude: ${latLng.latitude.toStringAsFixed(6)}\nLongitude: ${latLng.longitude.toStringAsFixed(6)}",
    //     ),
    //     duration: Duration(seconds: 2),
    //   ),
    // );

    cubit.openTripContainer();

    cubit.getAddress(
      lat: latLng.latitude,
      lng: latLng.longitude,
    );
  }

  void onCameraMoveStarted() {
    cubit.changeBuscandoFlag(false);
    if (!locationButtonFlag) {
      cubit.closeTripContainer();
    }
  }

  void onCameraMove(CameraPosition position) {
    cubit.zoomLevel = position.zoom;
    cubit.mapBearing = position.bearing;
    cubit.mapLocation = position.target;

    print("📍 الكاميرا تتحرك: ${position.target}");
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    cubit.mapController.complete(controller);
    mapController = controller;
    print("✅ Map جاهزة");
  }

  void showDriverOfferDialog() {
    if (currentOfferIndex < driverOffers.length) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            title: Text(
                S.of(context).driverOfferWithNumber(currentOfferIndex + 1)),
            content: DriverOfferList(
              offers: [driverOffers[currentOfferIndex]],
              onAcceptOffer: (offer) {
                setState(() {
                  driverOffers.remove(offer);
                });
                Navigator.of(context).pop();
                showNextOffer();
              },
              onRefuseOffer: (offer) {
                setState(() {
                  driverOffers.remove(offer);
                });
                Navigator.of(context).pop();
                showNextOffer();
              },
            ),
          );
        },
      );
    }
  }

  void showNextOffer() {
    currentOfferIndex++;
    if (currentOfferIndex < driverOffers.length) {
      showDriverOfferDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        cubit = HomeCubit.get(context);

        if (state is OpenTripContainerHomeState) {
          if (_bottomSheetController == null) {
            _bottomSheetController = _scaffoldKey.currentState?.showBottomSheet(
              enableDrag: false,
              backgroundColor: Colors.transparent,
              elevation: 6,
              (context) => WillPopScope(
                onWillPop: () async => false,
                child: TripInfoColumnWidget(
                  destinationController: destinationController,
                  cubit: cubit,
                  tripTypeList: cubit.tripTypeList,
                  offerController: offerController,
                  onLocationTap: () {
                    locationButtonFlag = true;
                    cubit.getMyLocation();
                    cubit.getAddress(
                      lat: cubit.mapLocation.latitude,
                      lng: cubit.mapLocation.longitude,
                    );
                  },
                ),
              ),
            );

            _bottomSheetController!.closed.then((_) {
              _bottomSheetController = null;
            });
          }
        }

        if (state is CloseTripContainerHomeState) {
          _bottomSheetController?.close();
          _bottomSheetController = null;
        }

        if (state is RideRequestSuccessState) {
          setState(() {
            driverOffers = [
              DriverOffer(driverName: S.of(context).driverA, price: 20),
              DriverOffer(driverName: S.of(context).driverB, price: 18),
              DriverOffer(driverName: S.of(context).driverC, price: 15),
            ];
            currentOfferIndex = 0;
          });
          showDriverOfferDialog();
        }
      },
      builder: (context, state) {
        cubit = HomeCubit.get(context);
        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          drawer: const CustomDrawer(),
          body: SafeArea(
            child: Stack(
              children: [
                // Map & marker

                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    UserMapWidget(
                      onCameraIdle: onCameraIdle,
                      onCameraMove: onCameraMove,
                      onCameraMoveStarted: onCameraMoveStarted,
                      onMapCreated: onMapCreated,
                      cubit: cubit,
                      cars: [],
                    ),
                    Positioned(
                      // top: -markerOffset,
                      top: markerHeight + markerOffset,
                      child: MarkerOfUserOnMapWidget(
                        buscando: cubit.buscando,
                        header: cubit.address,
                        markerHeight: markerHeight,
                      ),
                    ),
                    Positioned(
                        top: 80.h,
                        child: Icon(
                          Icons.circle_outlined,
                          color: Colors.red,
                          size: 20.r,
                        )),
                  ],
                ),
                // Drawer button
                Align(
                  alignment: Alignment.topLeft,
                  child: MyDrawerButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
