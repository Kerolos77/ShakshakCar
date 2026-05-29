class NewRideUserEntity {
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

  NewRideUserEntity({
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
}
