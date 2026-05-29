import 'dart:convert';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';

class SavedPlaceModel extends SavedPlaceEntity {
  SavedPlaceModel({
    required super.id,
    required super.name, // mapped to "label" from API
    required super.address,
    required super.lat,
    required super.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': name,
      'address': address,
      'latitude': lat.toString(),
      'longitude': lng.toString(),
    };
  }

  factory SavedPlaceModel.fromMap(Map<String, dynamic> map) {
    return SavedPlaceModel(
      id: map['id']?.toString() ?? '',
      name: map['label'] ?? map['name'] ?? '',
      address: map['address'] ?? '',
      lat: double.tryParse(map['latitude']?.toString() ?? '') ??
          map['lat']?.toDouble() ??
          0.0,
      lng: double.tryParse(map['longitude']?.toString() ?? '') ??
          map['lng']?.toDouble() ??
          0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedPlaceModel.fromJson(String source) =>
      SavedPlaceModel.fromMap(json.decode(source));
}
