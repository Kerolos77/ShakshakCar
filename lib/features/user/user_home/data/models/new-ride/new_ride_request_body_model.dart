class NewRideRequestBodyModel {
  final int serviceId;
  final String distance;
  final String destinationAddress;
  final String destinationLat;
  final String destinationLong;
  final String sourceAddress;
  final String sourceLat;
  final String sourceLong;
  final String offerRate;
  final bool interCity;
  final String paymentType;
  final DateTime whenDate;
  final int numberOfPassenger;
  final bool? femaleOnly;
  final int? savedCardId;
  
  // Shipment fields
  final String? receiverName;
  final String? receiverPhone;
  final String? parcelWeight;
  final String? parcelDimension;
  final String? parcelImagePath;

  NewRideRequestBodyModel({
    required this.serviceId,
    required this.distance,
    required this.destinationAddress,
    required this.destinationLat,
    required this.destinationLong,
    required this.sourceAddress,
    required this.sourceLat,
    required this.sourceLong,
    required this.offerRate,
    required this.interCity,
    required this.paymentType,
    required this.whenDate,
    required this.numberOfPassenger,
    this.femaleOnly,
    this.savedCardId,
    this.receiverName,
    this.receiverPhone,
    this.parcelWeight,
    this.parcelDimension,
    this.parcelImagePath,
  });

  /// ✅ From API
  factory NewRideRequestBodyModel.fromJson(Map<String, dynamic> json) {
    return NewRideRequestBodyModel(
      serviceId: int.parse(json['service_id'].toString()),
      distance: json['distance'].toString(),
      destinationAddress: json['destination_address'] ?? '',
      destinationLat: json['destination_lat'].toString(),
      destinationLong: json['destination_long'].toString(),
      sourceAddress: json['source_address'] ?? '',
      sourceLat: json['source_lat'].toString(),
      sourceLong: json['source_long'].toString(),
      offerRate: json['offer_rate'].toString(),
      interCity: json['inter_city'].toString() == '1',
      paymentType: json['payment_type'] ?? '',
      whenDate: DateTime.parse(json['when_date']),
      numberOfPassenger: int.parse(json['number_of_passenger'].toString()),
      femaleOnly: json['is_female_only']?.toString() == '1',
      savedCardId: json['saved_card_id'] != null ? int.tryParse(json['saved_card_id'].toString()) : null,
      receiverName: json['receiver_name'],
      receiverPhone: json['receiver_phone'],
      parcelWeight: json['parcel_weight'],
      parcelDimension: json['parcel_dimension'],
      parcelImagePath: json['parcel_image'],
    );
  }

  /// ✅ To API (JSON)
  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'distance': distance,
      'destination_address': destinationAddress,
      'destination_lat': destinationLat,
      'destination_long': destinationLong,
      'source_address': sourceAddress,
      'source_lat': sourceLat,
      'source_long': sourceLong,
      'offer_rate': offerRate,
      'inter_city': interCity ? 1 : 0,
      'payment_type': paymentType,
      'when_date': whenDate.toIso8601String(),
      'number_of_passenger': numberOfPassenger,
      'is_female_only': femaleOnly == true ? 1 : 0,
      if (savedCardId != null) 'saved_card_id': savedCardId,
      if (receiverName != null) 'receiver_name': receiverName,
      if (receiverPhone != null) 'receiver_phone': receiverPhone,
      if (parcelWeight != null) 'parcel_weight': parcelWeight,
      if (parcelDimension != null) 'parcel_dimension': parcelDimension,
      // Note: parcel_image cannot be sent as string in JSON for file upload. Use toFormData().
    };
  }

  /// ✅ To API (FormData) for file uploads
  Future<dynamic> toFormData() async {
    final Map<String, dynamic> data = toJson();
    
    // Create FormData from the existing JSON map
    // We must use dynamic to avoid importing Dio here if it's not imported,
    // but typically we can just return a Map and let the repo handle FormData conversion.
    // Let's return a Map, but include the file path if present, and repo handles the actual MultipartFile.
    if (parcelImagePath != null) {
      data['parcel_image_path'] = parcelImagePath; // Repo will read this
    }
    return data;
  }
}
