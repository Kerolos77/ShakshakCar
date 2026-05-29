import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shakshak/core/utils/converts.dart';

import 'package:shakshak/core/constants/key_const.dart';
import 'package:shakshak/features/user/user_home/data/models/place_model.dart';
import 'package:shakshak/features/user/user_home/domain/usecases/get_nearby_drivers_usecase.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';
import 'location_states.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetNearbyDriversUseCase getNearbyDriversUseCase;

  LocationCubit(this.getNearbyDriversUseCase) : super(InitialUserHomeState());

  static LocationCubit get(context) => BlocProvider.of(context);
  LatLng mapLocation = const LatLng(0, 0);
  Completer<GoogleMapController> mapController = Completer();

  Location location = Location();
  bool buscando = false;

  var zoomLevel = 17.0;
  var mapBearing = 0.0;
  PlacePrediction? sourcePlace;
  PlacePrediction? destinationPlace;

  TextEditingController? sourceController = TextEditingController();
  TextEditingController? destinationController = TextEditingController();

  bool isSourceSelected = false;
  bool isConfirmedDestinations = false;

  List<PlacePrediction> placePredictions = [];
  List<LatLng> nearbyDrivers = [];

  void changeLocation(
    LatLng lat,
  ) {
    mapLocation = lat;
  }

  void changeBuscandoFlag(bool flag) {
    buscando = flag;
    emit(ChangeBuscandoFlagUserHomeState());
  }

  static bool _isBuscando = false;

  Future<void> getMyLocation() async {
    if (_isBuscando) return;
    _isBuscando = true;
    buscando = true;
    emit(ChangeBuscandoFlagUserHomeState());

    print("ðŸ“ getMyLocation: Start");
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        print("ðŸ“ getMyLocation: Service disabled, requesting...");
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print("ðŸ“ getMyLocation: Service still disabled");
          _isBuscando = false;
          buscando = false;
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        print("ðŸ“ getMyLocation: Permission denied, requesting...");
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print("ðŸ“ getMyLocation: Permission still denied");
          _isBuscando = false;
          buscando = false;
          return;
        }
      }

      print("ðŸ“ getMyLocation: Calling location.getLocation()...");

      // Set settings for better accuracy/speed
      await location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 1000,
        distanceFilter: 0,
      );

      final value = await location.getLocation().timeout(
        const Duration(seconds: 7),
        onTimeout: () {
          print("ðŸ“ getMyLocation: Timeout occurred after 7 seconds");
          throw TimeoutException("Location request timed out");
        },
      );

      print(
          "ðŸ“ getMyLocation: Received Location: ${value.latitude}, ${value.longitude}");

      selectPlace(lat: value.latitude!, lng: value.longitude!, isSource: true);
      changeLocation(
        LatLng(value.latitude!, value.longitude!),
      );
      animateCamera();
    } catch (e) {
      print("ðŸ“ getMyLocation: Error: $e");
      emit(UserHomeErrorState("Failed to get location: $e"));
    } finally {
      _isBuscando = false;
      buscando = false;
      emit(ChangeBuscandoFlagUserHomeState());
    }
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

  Future<PlacePrediction?> getAddress(double lat, double lng) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${KeyConst.mapKey}&language=ar",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "OK" && data["results"].isNotEmpty) {
          final result = data["results"][0];

          return PlacePrediction(
            description: result["formatted_address"],
            placeId: result["place_id"] ?? "",
            mainText: result["address_components"][0]["long_name"] ?? "",
            secondaryText: result["formatted_address"],
            types: (result["types"] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(),
            terms: null,
            placeName: result["formatted_address"]
                .split(RegExp(r'[,،,]'))
                .first
                .trim(),
            lat: lat,
            lng: lng,
          );
        }
      }
      return null;
    } catch (e) {
      print("Error in getAddress: $e");
      return null;
    }
  }

  Future<void> getPlacesSuggestions(String input) async {
    if (input.isEmpty) {
      placePredictions = [];
      emit(SuggestionsLoadedState(placePredictions));
      return;
    }
    final languageCode = Converts().detectLanguageCodeByUnicode(input);
    print("detected language code: $languageCode");
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json"
      "?input=$input"
      "&key=${KeyConst.mapKey}"
      "&components=country:eg"
      "&language=$languageCode",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "OK") {
          final predictions = data["predictions"] as List;
          placePredictions = predictions
              .map((p) => PlacePrediction.fromAutocomplete(p))
              .toList();

          emit(SuggestionsLoadedState(placePredictions));
        } else {
          placePredictions = [];
          emit(SuggestionsLoadedState(placePredictions));
          print("Places API error: ${data["status"]}");
        }
      } else {
        throw Exception("Failed request: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      placePredictions = [];
      emit(SuggestionsLoadedState(placePredictions));
    }
  }

  Future<PlacePrediction?> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json"
      "?place_id=$placeId"
      "&key=${KeyConst.mapKey}"
      "&language=ar",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "OK") {
          final details = data["result"];

          return PlacePrediction(
            description: details["formatted_address"] ?? "",
            placeId: details["place_id"],
            mainText: details["name"] ?? "",
            secondaryText: details["vicinity"] ?? "",
            lat: details["geometry"]["location"]["lat"],
            lng: details["geometry"]["location"]["lng"],
            types: (details["types"] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(),
          );
        }
      }
    } catch (e) {
      print("Error fetching place details: $e");
    }
    return null;
  }

  Future<void> selectPlace({
    String? placeId,
    double? lat,
    double? lng,
    required bool isSource, // true = source, false = destination
    String? manualName,
  }) async {
    print(
        "ðŸ“  selectPlace: placeId: $placeId, lat: $lat, lng: $lng, isSource: $isSource, manualName: $manualName");
    try {
      PlacePrediction? place;

      if (placeId != null) {
        final details = await getPlaceDetails(placeId);
        place = details;
      } else if (lat != null && lng != null) {
        final addressData = await getAddress(lat, lng);
        place = addressData;
      }

      if (place != null) {
        String displayName = manualName ??
            (place.mainText.isNotEmpty
                ? place.mainText
                : (place.placeName ?? place.description));

        if (isSource) {
          sourcePlace = place;
          sourceController!.text = displayName;
        } else {
          destinationPlace = place;
          destinationController!.text = displayName;
        }
        emit(PlaceSelectedState(sourcePlace, destinationPlace));
      }
    } catch (e) {
      print("Error selecting place: $e");
      emit(UserHomeErrorState("Failed to select place"));
    }
  }

  Future<void> setDestinationFromCoordinates(double lat, double lng,
      {String? manualName}) async {
    emit(PlaceDetailsLoadingState());
    await selectPlace(
        lat: lat, lng: lng, isSource: false, manualName: manualName);
  }

  void clearPlace({required bool isSource}) {
    if (isSource) {
      sourcePlace = null;
    } else {
      destinationPlace = null;
    }
  }

  void confirmDestinations() {
    isConfirmedDestinations = true;
    emit(ConfirmDestinationsState());
  }

  double calculateDistanceKm(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  Future<void> getNearbyDrivers() async {
    emit(NearbyDriversLoading());
    final result = await getNearbyDriversUseCase(GetNearbyDriversUseCaseParams(
      latitude: mapLocation.latitude,
      longitude: mapLocation.longitude,
    ));

    result.fold(
      (failure) => emit(NearbyDriversFailure(failure.message)),
      (data) {
        try {
          // Assuming data is a Map with a 'drivers' key containing list of objects with lat/lng
          // or just a direct list of objects. I'll handle common formats.
          List<dynamic> driversList = [];
          if (data is List) {
            driversList = data;
          } else if (data is Map && data['data'] is List) {
            driversList = data['data'];
          } else if (data is Map && data['drivers'] is List) {
            driversList = data['drivers'];
          }

          nearbyDrivers = driversList.map((e) {
            return LatLng(
              double.parse(e['latitude'].toString()),
              double.parse(e['longitude'].toString()),
            );
          }).toList();

          emit(NearbyDriversSuccess(data));
        } catch (e) {
          debugPrint("Error parsing nearby drivers: $e");
          emit(NearbyDriversFailure("Error parsing data"));
        }
      },
    );
  }

  void updateFromRide(NewRideDataEntity ride) {
    sourcePlace = PlacePrediction(
      description: ride.sourceAddress,
      placeId: "",
      mainText: ride.sourceAddress.split(RegExp(r'[,،,]')).first.trim(),
      secondaryText: ride.sourceAddress,
      lat: ride.sourceLat,
      lng: ride.sourceLong,
    );
    sourceController?.text = sourcePlace!.mainText;

    destinationPlace = PlacePrediction(
      description: ride.destinationAddress,
      placeId: "",
      mainText: ride.destinationAddress.split(RegExp(r'[,،,]')).first.trim(),
      secondaryText: ride.destinationAddress,
      lat: ride.destinationLat,
      lng: ride.destinationLong,
    );
    destinationController?.text = destinationPlace!.mainText;

    emit(PlaceSelectedState(sourcePlace, destinationPlace));
  }
}
