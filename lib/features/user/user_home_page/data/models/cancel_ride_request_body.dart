class CancelRideRequestBody {
  int? rideRequestsId;

  CancelRideRequestBody({this.rideRequestsId});

  CancelRideRequestBody.fromJson(Map<String, dynamic> json) {
    rideRequestsId = json['rideRequestsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rideRequestsId'] = this.rideRequestsId;
    return data;
  }
}
