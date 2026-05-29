class CalcPriceTimeDistanceResponse {
  Data? data;

  CalcPriceTimeDistanceResponse({this.data});

  CalcPriceTimeDistanceResponse.fromJson(Map<String, dynamic> json) {
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
  Body? body;

  Data({this.mas, this.statusCode, this.body});

  Data.fromJson(Map<String, dynamic> json) {
    mas = json['mas'];
    statusCode = json['statusCode'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mas'] = this.mas;
    data['statusCode'] = this.statusCode;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  dynamic price;
  dynamic distance;
  dynamic time;

  Body({this.price, this.distance, this.time});

  Body.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    distance = json['distance'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['distance'] = this.distance;
    data['time'] = this.time;
    return data;
  }
}
