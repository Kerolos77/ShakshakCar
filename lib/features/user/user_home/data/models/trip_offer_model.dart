class TripOfferModel {
  final int id;
  final double destinationLat;
  final double destinationLong;
  final String destinationAddress;
  final double sourceLat;
  final double sourceLong;
  final String sourceAddress;
  final String amount;
  final String finalRate;
  final String isOffer;
  final double distance;
  final String status;
  final String userName;
  final String userImage;
  final String userPhone;
  final int offerRate;
  final num offerDriver;
  final String createdAt;
  final List<dynamic> offers;
  final int driverId;
  final String driverName;
  final String driverPhone;
  final String driverImage;
  final String carColor;
  final String carNumber;
  final String carBrand;
  final String carModel;

  TripOfferModel({
    required this.id,
    required this.destinationLat,
    required this.destinationLong,
    required this.destinationAddress,
    required this.sourceLat,
    required this.sourceLong,
    required this.sourceAddress,
    required this.amount,
    required this.finalRate,
    required this.isOffer,
    required this.distance,
    required this.status,
    required this.userName,
    required this.userImage,
    required this.userPhone,
    required this.offerRate,
    required this.offerDriver,
    required this.createdAt,
    required this.offers,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.driverImage,
    required this.carColor,
    required this.carNumber,
    required this.carBrand,
    required this.carModel,
  });

  /// ---------- helpers آمنة ----------
  static String _string(dynamic v) => v?.toString() ?? '';

  static int _int(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  static double _double(dynamic v) =>
      double.tryParse(v?.toString() ?? '') ?? 0.0;

  static num _num(dynamic v) => num.tryParse(v?.toString() ?? '') ?? 0;

  static List<dynamic> _list(dynamic v) => v is List ? v : [];

  /// ---------- fromJson آمن ----------
  factory TripOfferModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    // --- Handling wrapped payloads (data or offer keys) ---
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data.containsKey('id') || data.containsKey('offer_id')) {
        json = data;
      }
    } else if (json.containsKey('offer') && json['offer'] is Map<String, dynamic>) {
      final offer = json['offer'] as Map<String, dynamic>;
      if (offer.containsKey('id') || offer.containsKey('offer_id')) {
        json = offer;
      }
    }

    return TripOfferModel(
      id: _int(json['offer_id'] ?? json['id']),
      destinationLat: _double(json['destination_lat']),
      destinationLong: _double(json['destination_long']),
      destinationAddress: _string(json['destination_address']),
      sourceLat: _double(json['source_lat']),
      sourceLong: _double(json['source_long']),
      sourceAddress: _string(json['source_address']),
      amount: _string(json['amount']),
      finalRate: _string(json['final_rate']),
      isOffer: _string(json['is_offer']),
      distance: _double(json['distance']),
      status: _string(json['status']),
      userName: _string(json['user_name']),
      userImage: _string(json['user_image']),
      userPhone: _string(json['user_phone']),
      offerRate: _int(json['offer_rate'] ?? json['id']),
      offerDriver: _numSafe(_num(json['driver_offer'] ??
          json['offer_rate'] ??
          json['offer_driver'] ??
          json['offerdriver'] ??
          json['amount'])),
      createdAt: _string(json['created_at']),
      offers: _list(json['offers']),
      driverId: _int(json['driver']?['id'] ?? json['driver_id']),
      driverName: _string(
          json['driver']?['name'] ?? json['driver_name'] ?? json['name']),
      driverPhone: _string(json['driver']?['phone_number'] ??
          json['driver_phone'] ??
          json['phone_number']),
      driverImage: _string(json['driver']?['profile_pic'] ??
          json['driver_image'] ??
          json['imageurl']),
      carColor: _string(json['car_color']),
      carNumber: _string(json['car_number']),
      carBrand: _string(json['car_brand']),
      carModel: _string(json['car_model']),
    );
  }

  static num _numSafe(dynamic v) {
    if (v == null) return 0; // لو null رجع 0
    if (v is num) return v; // لو أصلاً num رجعها مباشرة
    return num.tryParse(v.toString()) ??
        0; // لو string أو int أو أي حاجة حاول parse
  }
}
