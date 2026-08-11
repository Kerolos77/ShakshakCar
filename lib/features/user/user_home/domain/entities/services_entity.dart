class ServicesEntity {
  ServicesEntity({
    this.data,
  });

  List<ServiceDataEntity>? data;
}

class ServiceDataEntity {
  ServiceDataEntity({
    this.id,
    this.name,
    this.image,
    this.offerRate,
    this.serviceType,
    this.vehicleType,
  });

  num? id;
  String? name;
  String? image;
  String? offerRate;
  String? serviceType;
  String? vehicleType;
}
