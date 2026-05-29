import 'package:shakshak/features/shared/rides/domain/entities/rides_data_entity.dart';

class RidesEntity {
  final RidesDataEntity? data;
  final String? msg;
  final int? status;
  final bool? statusval;

  RidesEntity({
    this.data,
    this.msg,
    this.status,
    this.statusval,
  });
}
