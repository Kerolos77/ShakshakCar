class ForgetPasswordModel {
  ForgetPasswordModel({
    this.status,
    this.message,
    this.data,
  });

  ForgetPasswordModel.fromJson(dynamic json) {
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
    this.userId,
    this.otp,
    this.expiresAt,
  });

  Data.fromJson(dynamic json) {
    userId = json['user_id'];
    otp = json['otp'];
    expiresAt = json['expires_at'];
  }

  int? userId;
  int? otp;
  String? expiresAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['otp'] = otp;
    map['expires_at'] = expiresAt;
    return map;
  }
}
