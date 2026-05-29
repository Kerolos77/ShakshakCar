import 'package:shakshak/features/driver/new_rides/domain/entities/negotiation_settings_entity.dart';

class NegotiationSettingsModel extends NegotiationSettingsEntity {
  const NegotiationSettingsModel({
    required super.data,
    required super.activeType,
  });

  factory NegotiationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NegotiationSettingsModel(
      data: json['data'] != null ? List<String>.from(json['data']) : [],
      activeType: json['active_type'] ?? '',
    );
  }
}
