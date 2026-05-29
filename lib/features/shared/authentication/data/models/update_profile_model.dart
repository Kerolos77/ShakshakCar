class UpdateProfileModel {
  UpdateProfileModel({
    this.status,
    this.message,
    this.data,
  });

  UpdateProfileModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.name,
    this.phone,
    this.email,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['mobile'];
    email = json['email'];
  }
  int? id;
  String? name;
  String? phone;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['mobile'] = phone;
    map['email'] = email;

    return map;
  }
}
