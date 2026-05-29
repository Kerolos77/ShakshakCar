class RequestRideRequestBody {
  String? pickupAddress;
  double? pickupLatitude;
  double? pickupLongitude;
  String? dropOffAddress;
  double? dropoffLatitude;
  double? dropoffLongitude;
  String? category;
  double? farePrice;

  RequestRideRequestBody(
      {this.pickupAddress,
        this.pickupLatitude,
        this.pickupLongitude,
        this.dropOffAddress,
        this.dropoffLatitude,
        this.dropoffLongitude,
        this.category,
        this.farePrice});

  RequestRideRequestBody.fromJson(Map<String, dynamic> json) {
    pickupAddress = json['pickupAddress'];
    pickupLatitude = json['pickupLatitude'];
    pickupLongitude = json['pickupLongitude'];
    dropOffAddress = json['dropOffAddress'];
    dropoffLatitude = json['dropoffLatitude'];
    dropoffLongitude = json['dropoffLongitude'];
    category = json['category'];
    farePrice = json['farePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pickupAddress'] = this.pickupAddress;
    data['pickupLatitude'] = this.pickupLatitude;
    data['pickupLongitude'] = this.pickupLongitude;
    data['dropOffAddress'] = this.dropOffAddress;
    data['dropoffLatitude'] = this.dropoffLatitude;
    data['dropoffLongitude'] = this.dropoffLongitude;
    data['category'] = this.category;
    data['farePrice'] = this.farePrice;
    return data;
  }
}
