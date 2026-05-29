class CalcPriceTimeDistanceRequestBody {
  String? category;
  String? droppOffLat;
  String? droppOffLon;
  String? pickUpLat;
  String? pickUpLon;

  CalcPriceTimeDistanceRequestBody(
      {this.category,
        this.droppOffLat,
        this.droppOffLon,
        this.pickUpLat,
        this.pickUpLon});

  CalcPriceTimeDistanceRequestBody.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    droppOffLat = json['droppOffLat'];
    droppOffLon = json['droppOffLon'];
    pickUpLat = json['pickUpLat'];
    pickUpLon = json['pickUpLon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['droppOffLat'] = this.droppOffLat;
    data['droppOffLon'] = this.droppOffLon;
    data['pickUpLat'] = this.pickUpLat;
    data['pickUpLon'] = this.pickUpLon;
    return data;
  }
}
