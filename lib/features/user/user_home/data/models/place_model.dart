class PlacePrediction {
  final String description;
  final String placeId;
  final String mainText;
  final String secondaryText;
  final List<String>? types;
  final List<dynamic>? terms;
  final String? placeName;
  final double? lat;
  final double? lng;

  PlacePrediction({
    required this.description,
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    this.types,
    this.terms,
    this.placeName,
    this.lat,
    this.lng,
  });

  factory PlacePrediction.fromAutocomplete(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json["description"],
      placeId: json["place_id"],
      mainText: json["structured_formatting"]["main_text"],
      secondaryText: json["structured_formatting"]["secondary_text"],
      types:
          (json["types"] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      terms: json["terms"],
      placeName: json["description"]
          .split(RegExp(r'[,،,]')) // يعمل split على الفاصلة الانجليزي والعربي
          .first
          .trim(),
    );
  }

  PlacePrediction copyWithDetails(Map<String, dynamic> details) {
    final location = details["geometry"]["location"];
    return PlacePrediction(
      description: description,
      placeId: placeId,
      mainText: mainText,
      secondaryText: secondaryText,
      types: types,
      terms: terms,
      lat: location["lat"],
      lng: location["lng"],
      placeName: placeName,
    );
  }
}
