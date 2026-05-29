class NewPasswordModel {
  NewPasswordModel({
    this.status,
    this.message,
    this.data,
  });

  NewPasswordModel.fromJson(dynamic json) {
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
    this.user,
    this.token,
  });

  Data.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  User? user;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['token'] = token;
    return map;
  }
}

class User {
  User({
    this.id,
    this.name,
    this.nameEn,
    this.email,
    this.roleId,
    this.twoFactorConfirmedAt,
    this.phone,
    this.gender,
    this.birthDate,
    this.verfiedAt,
    this.isTrusted,
    this.profilePhotoPath,
    this.identificationVerifiedAt,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.description,
    this.onesignalId,
    this.userLang,
    this.online,
    this.userName,
    this.isActive,
    this.verifyAccountOneTime,
    this.profilePhotoUrl,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    email = json['email'];
    roleId = json['role_id'];
    twoFactorConfirmedAt = json['two_factor_confirmed_at'];
    phone = json['phone'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    verfiedAt = json['verfied_at'];
    isTrusted = json['is_trusted'];
    profilePhotoPath = json['profile_photo_path'];
    identificationVerifiedAt = json['identification_verified_at'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    description = json['description'];
    onesignalId = json['onesignal_id'];
    userLang = json['user_lang'];
    online = json['online'];
    userName = json['user_name'];
    isActive = json['is_active'];
    verifyAccountOneTime = json['verify_account_one_time'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  int? id;
  String? name;
  String? nameEn;
  String? email;
  int? roleId;
  String? twoFactorConfirmedAt;
  String? phone;
  String? gender;
  String? birthDate;
  String? verfiedAt;
  String? isTrusted;
  String? profilePhotoPath;
  String? identificationVerifiedAt;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? description;
  String? onesignalId;
  String? userLang;
  String? online;
  String? userName;
  String? isActive;
  String? verifyAccountOneTime;
  String? profilePhotoUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['name_en'] = nameEn;
    map['email'] = email;
    map['role_id'] = roleId;
    map['two_factor_confirmed_at'] = twoFactorConfirmedAt;
    map['phone'] = phone;
    map['gender'] = gender;
    map['birth_date'] = birthDate;
    map['verfied_at'] = verfiedAt;
    map['is_trusted'] = isTrusted;
    map['profile_photo_path'] = profilePhotoPath;
    map['identification_verified_at'] = identificationVerifiedAt;
    map['email_verified_at'] = emailVerifiedAt;
    map['phone_verified_at'] = phoneVerifiedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['description'] = description;
    map['onesignal_id'] = onesignalId;
    map['user_lang'] = userLang;
    map['online'] = online;
    map['user_name'] = userName;
    map['is_active'] = isActive;
    map['verify_account_one_time'] = verifyAccountOneTime;
    map['profile_photo_url'] = profilePhotoUrl;
    return map;
  }
}
