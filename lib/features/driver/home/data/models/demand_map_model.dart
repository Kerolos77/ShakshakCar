class DemandMapModel {
  final List<HexagonModel> hexagons;

  DemandMapModel({required this.hexagons});

  factory DemandMapModel.fromJson(Map<String, dynamic> json) {
    return DemandMapModel(
      hexagons: (json['hexagons'] as List? ?? [])
          .map((e) => HexagonModel.fromJson(e))
          .toList(),
    );
  }
}

class HexagonModel {
  final String id;
  final double lat;
  final double lng;
  final int count;
  final String intensity; // low, medium, high

  HexagonModel({
    required this.id,
    required this.lat,
    required this.lng,
    required this.count,
    required this.intensity,
  });

  factory HexagonModel.fromJson(Map<String, dynamic> json) {
    return HexagonModel(
      id: json['id'],
      lat: (json['center']['lat'] ?? 0).toDouble(),
      lng: (json['center']['lng'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
      intensity: json['intensity'] ?? 'low',
    );
  }
}
