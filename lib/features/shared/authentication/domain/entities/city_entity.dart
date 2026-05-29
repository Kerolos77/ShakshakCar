class CityEntity {
  final List<CityDataEntity>? data;
  final String? msg;
  final int? status;
  final bool? statusval;

  const CityEntity({
    this.data,
    this.msg,
    this.status,
    this.statusval,
  });
}

class CityDataEntity {
  final int? id;
  final String? name;
  final String? latitude;
  final String? longitude;

  const CityDataEntity({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
  });
}
