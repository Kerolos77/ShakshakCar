import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shakshak/features/user/user_home_page/data/models/calc_price_time_distance_request_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/calc_price_time_distance_response.dart';
import 'package:shakshak/features/user/user_home_page/data/models/cancel_ride_request_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/request_ride_request_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/ride_request_response_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/trip_type_model.dart';
import 'package:shakshak/features/user/user_home_page/data/repository/user_home_repository.dart';
import 'home_states.dart';


class HomeCubit extends Cubit<HomeState> {
  // UserHomeRepository userHomeRepository;

  HomeCubit(
      // this.userHomeRepository
      ) : super(InitialHomeState()) {}

  static HomeCubit get(context) => BlocProvider.of(context);

  calcPriceAndTimeDistance(
      {required CalcPriceTimeDistanceRequestBody
          calcPriceTimeDistanceRequestBody})
  {
    emit(CalcPriceAndTimeDistanceLoadingState());
    emit(CalcPriceAndTimeDistanceSuccessState());
    // userHomeRepository
    //     .calcPriceAndTimeDistance(
    //         calcPriceTimeDistanceRequestBody: calcPriceTimeDistanceRequestBody)
    //     .then((value) {
    //   value.whenOrNull(success: (data) {
    //     emit(
    //       CalcPriceAndTimeDistanceSuccessState(
    //         calcPriceTimeDistanceResponse:
    //             CalcPriceTimeDistanceResponse.fromJson(data),
    //       ),
    //     );
    //   }, failure: (error) {
    //     emit(CalcPriceAndTimeDistanceErrorState(
    //         error: NetworkExceptions.getErrorMessage(error)));
    //   });
    // });
  }

  requestRide({required RequestRideRequestBody requestRideRequestBody})
  {
    emit(RideRequestLoadingState());
    emit(RideRequestSuccessState(

    ));
    // userHomeRepository
    //     .requestRide(requestRideRequestBody: requestRideRequestBody)
    //     .then((value) {
    //   value.whenOrNull(success: (data) {
    //     emit(
    //       RideRequestSuccessState(
    //         rideRequestResponseBody: RideRequestResponseBody.fromJson(data),
    //       ),
    //     );
    //   }, failure: (error) {
    //     emit(RideRequestErrorState(
    //         error: NetworkExceptions.getErrorMessage(error)));
    //   });
    // });
  }

  cancelRideRequestByPassenger(
      {required CancelRideRequestBody cancelRideRequestBody})
  {
    emit(CancelRideRequestPassengerLoadingState());
    emit(CancelRideRequestPassengerSuccessState());
    // userHomeRepository
    //     .cancelRideRequestByPassenger(
    //         cancelRideRequestBody: cancelRideRequestBody)
    //     .then((value) {
    //   value.whenOrNull(success: (data) {
    //     emit(
    //       CancelRideRequestPassengerSuccessState(
    //         cancelRideResponseBody: CancelRideResponseBody.fromJson(data),
    //       ),
    //     );
    //   }, failure: (error) {
    //     emit(CancelRideRequestPassengerErrorState(
    //         error: NetworkExceptions.getErrorMessage(error)));
    //   });
    // });
  }

  // getCategoryOfVehicle() async {
  //   emit(GetCategoryOfVehicleLoading());
  //   final result = await userHomeRepository.getCategoryOfVehicle();
  //   result.whenOrNull(success: (success) {
  //     tripTypeList = success.data!.body!;
  //     emit(GetCategoryOfVehicleSuccess(categoryOfVehicleResponse: success));
  //   }, failure: (failure) {
  //     emit(GetCategoryOfVehicleFailure(
  //         message: NetworkExceptions.getErrorMessage(failure)));
  //   });
  // }

  List<TripTypeModel> tripTypeList = [
    TripTypeModel(type: "Car", image: "assets/images/car1.png", info: "Car"),
    TripTypeModel(
        type: "comfort", image: "assets/images/car1.png", info: "comfort"),
    TripTypeModel(type: "Bike", image: "assets/images/bike.png", info: "Bike"),
    TripTypeModel(type: "VIP", image: "assets/images/car1.png", info: "VIP"),
    TripTypeModel(type: "Van", image: "assets/images/car1.png", info: "Van"),
  ];
  String selectedCategoryName = ""; // To hold the selected trip type name

  LatLng mapLocation = const LatLng(0, 0);

  bool locationButtonFlag = false;

  Completer<GoogleMapController> mapController = Completer();
  Location location = Location();
  bool buscando = false;
  var zoomLevel = 17.0;
  var mapBearing = 0.0;

  GeoCode geoCode = GeoCode();

  String address = 'No Address Found';

  String destinationAddress = 'No Address Found';
  bool destinationBuscando = false;
  LatLng destinationLocation = const LatLng(0, 0);

  void setDestination(LatLng latLng) {
    destinationLocation = latLng;
    getDestinationAddress(lat: latLng.latitude, lng: latLng.longitude);
  }

  int streetNumber = 0;

  void changeLocation(
    LatLng lat,
  ) {
    this.mapLocation = lat;
    animateCamera();
  }

  void changeLocationButtonFlag(bool flag) {
    locationButtonFlag = flag;
  }

  void changeBuscandoFlag(bool flag) {
    buscando = flag;
    emit(ChangeBuscandoFlagHomeState());
  }

  void changeBuscandoFlagForDestination(bool flag) {
    destinationBuscando = flag;
    emit(ChangeBuscandoFlagHomeState());
  }

  void openTripContainer() {
    emit(OpenTripContainerHomeState());
  }

  Future<void> closeTripContainer() async {
    emit(CloseTripContainerHomeState());
  }

  void getMyLocation() {
    location.getLocation().then((value) {
      print('get location');
      changeLocation(
        LatLng(value.latitude!, value.longitude!),
      ); animateCamera();
    });
  }

  void getMyLocationUpDate(context) {
    location.onLocationChanged.listen((LocationData currentLocation) {
      emit(GetMyLocationHomeState());
    });
  }

  Future<void> animateCamera() async {
    final GoogleMapController controller = await this.mapController.future;
    CameraPosition cameraPosition;
    cameraPosition = CameraPosition(
      target: mapLocation,
      zoom: zoomLevel,
      bearing: mapBearing,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // void sendNotification() {
  //   services.showNotification(
  //       id: 0,
  //       title: "Infraction",
  //       body:
  //       """Speed: ${speedMps.toStringAsFixed(0)} \n price : 100 """);
  // }
  //
  // void createAlert(BuildContext context) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(constUid)
  //       .get()
  //       .then((value) {
  //     firebaseRepo
  //         .createAlert(
  //       name: "${value.data()!['name']}",
  //       id: '$constUid',
  //       nationalID: '${value.data()!['nationalID']}',
  //       currentSpeed: speedMps.toStringAsFixed(0),
  //
  //       preSpeed: preSpeed.toStringAsFixed(0),
  //       carNumber: "${value.data()!['carNumber']}",
  //       price: "100 LE",
  //       address: address,
  //     );
  //   });
  // }

  getAddress({
    required double lat,
    required double lng,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    geoCode.reverseGeocoding(latitude: lat, longitude: lng).then((value) {
      address = value.streetAddress.toString();
      buscando = true;
      emit(SuccessGetAddressHomeState());
    }).then((value) {
      destinationAddress != 'No Address Found'
          ? getDestinationAddress(
              lat: destinationLocation.latitude,
              lng: destinationLocation.longitude)
          : null;
    });
  }

  getDestinationAddress({
    required double lat,
    required double lng,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    geoCode.reverseGeocoding(latitude: lat, longitude: lng).then((value) {
      destinationAddress = value.streetAddress.toString();
      destinationBuscando = true;
      emit(SuccessGetDestinationAddressHomeState());
    }).then((value) {
      calcPriceAndTimeDistance(
        calcPriceTimeDistanceRequestBody: CalcPriceTimeDistanceRequestBody(
          category: "vip",
          droppOffLat: destinationLocation.latitude.toString(),
          droppOffLon: destinationLocation.longitude.toString(),
          pickUpLat: mapLocation.latitude.toString(),
          pickUpLon: mapLocation.longitude.toString(),
        ),
      );
    });
  }
}
