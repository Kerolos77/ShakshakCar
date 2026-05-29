class CountryEntity {
  final List<CountryDataEntity>? data;
  final String? msg;
  final int? status;
  final bool? statusval;

  const CountryEntity({
    this.data,
    this.msg,
    this.status,
    this.statusval,
  });
}

class CountryDataEntity {
  final int? id;
  final String? name;
  final String? latitude;
  final String? longitude;

  const CountryDataEntity({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
  });
}
