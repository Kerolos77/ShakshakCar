class SavedPlaceEntity {
  final String id;
  final String name; // e.g., "Home", "Work"
  final String address;
  final double lat;
  final double lng;

  SavedPlaceEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
}
