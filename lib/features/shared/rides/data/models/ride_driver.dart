class RideDriver {
  RideDriver({
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
  });

  RideDriver.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    countryId = json['country_id'];
    city = json['city'];
    email = json['email'];
    walletAmount = json['wallet_amount'];
    pendingWallet = json['pending_wallet'];
    driverStatus = json['driver_status'];
    isDriver = json['is_driver'];
    isOnline = json['is_online'];
    serviceId = json['service_id'];
  }

  int? id;
  String? name;
  String? phone;
  String? image;
  int? countryId;
  int? city;
  String? email;
  String? walletAmount;
  String? pendingWallet;
  String? driverStatus;
  int? isDriver;
  int? isOnline;
  int? serviceId;
}
