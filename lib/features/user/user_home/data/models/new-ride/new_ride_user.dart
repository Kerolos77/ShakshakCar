import 'package:shakshak/features/user/user_home/domain/entities/new_ride_user_entity.dart';

class NewRideUser implements NewRideUserEntity {
  final int id;
  final String name;
  final String phone;
  final String image;
  final String countryId;
  final String? city;
  final String email;
  final double walletAmount;
  final double pendingWallet;
  final bool isDriver;
  final bool isOnline;
  final int serviceId;

  NewRideUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.image,
    required this.countryId,
    this.city,
    required this.email,
    required this.walletAmount,
    required this.pendingWallet,
    required this.isDriver,
    required this.isOnline,
    required this.serviceId,
  });

  /// ---------- helpers آمنة ----------
  static String _string(dynamic v) => v?.toString() ?? '';

  static int _int(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  static double _double(dynamic v) =>
      double.tryParse(v?.toString() ?? '') ?? 0.0;

  static bool _bool(dynamic v) => v?.toString() == '1' || v == true;

  factory NewRideUser.fromJson(dynamic json) {
    // إذا كان json ليس Map، نرجع قيم افتراضية
    if (json is! Map<String, dynamic>) {
      json = <String, dynamic>{};
    }

    return NewRideUser(
      id: _int(json['id']),
      name: _string(json['name']),
      phone: _string(json['phone']),
      image: _string(json['image']),
      countryId: _string(json['country_id']),
      city: json['city']?.toString(),
      email: _string(json['email']),
      walletAmount: _double(json['wallet_amount']),
      pendingWallet: _double(json['pending_wallet']),
      isDriver: _bool(json['is_driver']),
      isOnline: _bool(json['is_online']),
      serviceId: _int(json['service_id']),
    );
  }
}
