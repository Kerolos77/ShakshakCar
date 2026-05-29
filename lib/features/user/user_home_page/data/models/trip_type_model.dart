class TripTypeModel {
  late String type;
  late String image;
  late String info;

  TripTypeModel({
    required this.type,
    required this.image,
    required this.info,
  });

  TripTypeModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    image = json['image'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['image'] = this.image;
    data['info'] = this.info;
    return data;
  }
}
