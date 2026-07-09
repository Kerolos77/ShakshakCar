import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';

import 'shipment_state.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentCubit extends Cubit<ShipmentState> {
  ShipmentCubit() : super(ShipmentInitial());

  static ShipmentCubit get(context) => BlocProvider.of(context);

  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();
  final TextEditingController packageDetailsController = TextEditingController();
  
  String? selectedWeight;
  File? packageImage;
  bool acceptedTerms = false;
  int? selectedServiceId;
  
  // Payment variables
  String selectedPaymentMethod = 'cash';
  bool useWallet = false;

  void setWeight(String weight) {
    selectedWeight = weight;
    emit(ShipmentFormUpdated());
  }

  void toggleTerms(bool? value) {
    acceptedTerms = value ?? false;
    emit(ShipmentFormUpdated());
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    emit(ShipmentFormUpdated());
  }

  void toggleWallet(bool value) {
    useWallet = value;
    emit(ShipmentFormUpdated());
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      packageImage = File(pickedFile.path);
      emit(ShipmentFormUpdated());
    }
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      packageImage = File(pickedFile.path);
      emit(ShipmentFormUpdated());
    }
  }

  void removeImage() {
    packageImage = null;
    emit(ShipmentFormUpdated());
  }

  void submitShipmentRequest(BuildContext context) {
    final locationCubit = context.read<LocationCubit>();
    final userHomeCubit = context.read<UserHomeCubit>();

    if (locationCubit.sourcePlace == null || locationCubit.destinationPlace == null) {
      emit(ShipmentValidationError(message: S.of(context).selectPickupAndDropoff));
      return;
    }

    if (receiverNameController.text.trim().isEmpty) {
      emit(ShipmentValidationError(message: S.of(context).receiverNameRequired));
      return;
    }

    final String phone = receiverPhoneController.text.trim();
    if (phone.isEmpty) {
      emit(ShipmentValidationError(message: S.of(context).receiverPhoneRequired));
      return;
    }
    
    // Egyptian phone number format validation (starts with 01, followed by 0,1,2,5, and total 11 digits)
    final RegExp phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegExp.hasMatch(phone)) {
      emit(ShipmentValidationError(message: S.of(context).invalidPhone));
      return;
    }

    if (packageDetailsController.text.trim().isEmpty) {
      emit(ShipmentValidationError(message: S.of(context).packageDetailsRequired));
      return;
    }

    if (selectedWeight == null) {
      emit(ShipmentValidationError(message: S.of(context).selectPackageWeight));
      return;
    }

    if (packageImage == null) {
      emit(ShipmentValidationError(message: S.of(context).uploadPackageImageRequired));
      return;
    }

    if (!acceptedTerms) {
      emit(ShipmentValidationError(message: S.of(context).mustAgreeToTerms));
      return;
    }

    if (userHomeCubit.servicesDetails.isEmpty) {
      emit(ShipmentValidationError(message: S.of(context).errorOccurred));
      return;
    }

    // Find the shipping service from UserHomeCubit
    final shippingService = userHomeCubit.servicesDetails.firstWhere(
      (s) => s.service.serviceType == 'shipping',
      orElse: () => userHomeCubit.servicesDetails.first,
    );

    final double distance = locationCubit.calculateDistanceKm(
      locationCubit.sourcePlace!.lat!,
      locationCubit.sourcePlace!.lng!,
      locationCubit.destinationPlace!.lat!,
      locationCubit.destinationPlace!.lng!,
    );

    String mappedPaymentType = 'cash';
    int? mappedCardId;

    if (selectedPaymentMethod == 'cash') {
      mappedPaymentType = useWallet ? 'wallet_cash' : 'cash';
    } else {
      mappedCardId = int.tryParse(selectedPaymentMethod);
      mappedPaymentType = useWallet ? 'wallet_card' : 'saved_card';
    }

    final requestBody = NewRideRequestBodyModel(
      serviceId: shippingService.service.id?.toInt() ?? 1,
      distance: distance.toStringAsFixed(2),
      destinationAddress: locationCubit.destinationPlace?.mainText ?? '',
      destinationLat: locationCubit.destinationPlace!.lat!.toString(),
      destinationLong: locationCubit.destinationPlace!.lng!.toString(),
      sourceAddress: locationCubit.sourcePlace?.mainText ?? '',
      sourceLat: locationCubit.sourcePlace!.lat!.toString(),
      sourceLong: locationCubit.sourcePlace!.lng!.toString(),
      offerRate: "0",
      interCity: distance > 100, // Toggle interCity if distance exceeds 100km
      paymentType: mappedPaymentType,
      savedCardId: mappedCardId,
      whenDate: DateTime.now(),
      numberOfPassenger: 1,
      receiverName: receiverNameController.text.trim(),
      receiverPhone: phone,
      parcelWeight: selectedWeight,
      parcelDimension: packageDetailsController.text.trim(),
      parcelImagePath: packageImage!.path,
    );

    userHomeCubit.newRideRequest(newRideRequestBodyModel: requestBody);
  }

  @override
  Future<void> close() {
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    packageDetailsController.dispose();
    return super.close();
  }
}
