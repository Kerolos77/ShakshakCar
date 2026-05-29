class CancelRideResponseBody {
  Data? data;

  CancelRideResponseBody({this.data});

  CancelRideResponseBody.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? mas;
  int? statusCode;
  Null? body;

  Data({this.mas, this.statusCode, this.body});

  Data.fromJson(Map<String, dynamic> json) {
    mas = json['mas'];
    statusCode = json['statusCode'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mas'] = this.mas;
    data['statusCode'] = this.statusCode;
    data['body'] = this.body;
    return data;
  }
}
