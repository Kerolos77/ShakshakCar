class ProfileEntity {
  final int? status;
  final bool? statusval;
  final String? msg;
  final UserDataEntity? data;

  const ProfileEntity({
    this.status,
    this.statusval,
    this.msg,
    this.data,
  });
}

class UserDataEntity {
  final int? id;
  final String? name;
  final String? phone;
  final String? image;
  final int? countryId;
  final int? city;
  final String? email;
  final String? walletAmount;
  final String? pendingWallet;
  final String? driverStatus;
  final int? isDriver;
  final int? isOnline;
  final int? serviceId;
  final String? token;
  final String? gender;
  final int? rewardPoints;
  final int? cashRestrictionSecondsRemaining;
  final ActivePackage? activePackage;

  const UserDataEntity({
    this.id,
    this.name,
    this.phone,
    this.image,
    this.countryId,
    this.city,
    this.email,
    this.walletAmount,
    this.pendingWallet,
    this.driverStatus,
    this.isDriver,
    this.isOnline,
    this.serviceId,
    this.token,
    this.gender,
    this.rewardPoints,
    this.cashRestrictionSecondsRemaining,
    this.activePackage,
  });
}

class ActivePackage {
  final int id;
  final String name;
  final String? image;
  final String? expiresAt;

  const ActivePackage({required this.id, required this.name, this.image, this.expiresAt});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'expires_at': expiresAt,
    };
  }
}
