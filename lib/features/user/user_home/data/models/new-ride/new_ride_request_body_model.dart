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
    );
  }

  /// ✅ To API
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
    };
  }
}
