import 'package:shakshak/features/shared/authentication/domain/entities/profile_entity.dart';

class ProfileModel implements ProfileEntity {
  ProfileModel({
    this.status,
    this.statusval,
    this.msg,
    this.data,
  });

  ProfileModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['statusval'] is bool) {
      statusval = json['statusval'];
    } else {
      statusval = false;
    }

    msg = json['message'] ?? json['msg'];

    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = UserData.fromJson(json['data']);
    } else {
      data = null;
    }
  }

  int? status;

  bool? statusval;
  String? msg;
  UserData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['statusval'] = statusval;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class UserData implements UserDataEntity {
  UserData({
    this.id,
    this.name,
    this.phone,
    this.image,
    this.countryId,
    this.city,
    this.email,
    this.walletAmount,
    this.pendingWallet,
    this.driverStatus,
    this.isDriver,
    this.isOnline,
    this.serviceId,
    this.token,
    this.gender,
    this.rewardPoints,
    this.cashRestrictionSecondsRemaining,
    this.activePackage,
  });

  UserData.fromJson(dynamic json) {
    // Handle nested 'user' object if it exists (registration response)
    final userJson =
        json['user'] != null && json['user'] is Map<String, dynamic>
            ? json['user']
            : json;

    id = userJson['id'];
    name = userJson['name'];
    phone = userJson['phone'] ?? userJson['phone_number'];
    image = userJson['image'];
    countryId = userJson['country_id'] is int
        ? userJson['country_id']
        : int.tryParse(userJson['country_id']?.toString() ?? '');
    city = userJson['city'] is int
        ? userJson['city']
        : int.tryParse(userJson['city']?.toString() ?? '');
    email = userJson['email'];
    walletAmount = userJson['wallet_amount']?.toString();
    pendingWallet = userJson['pending_wallet']?.toString();
    driverStatus = userJson['driver_status']?.toString();
    isDriver = userJson['is_driver'] ?? 0; // Default to user if not provided
    isOnline = userJson['is_online'];
    serviceId = userJson['service_id'];
    token = json['token'] ?? userJson['token'];
    gender = userJson['gender'];
    rewardPoints = userJson['reward_points'];
    cashRestrictionSecondsRemaining = userJson['cash_restriction_seconds_remaining'];
    isVip = userJson['is_vip'] == true || userJson['is_vip'] == 1;
    vipTheme = userJson['vip_theme'] != null ? VipThemeModel.fromJson(userJson['vip_theme']) : null;
    activePackage = userJson['active_package'] != null ? ActivePackageModel.fromJson(userJson['active_package']) : null;
  }

  int? id;
  String? name;
  String? phone;
  String? image;
  int? countryId;
  int? city;
  String? email;
  String? walletAmount;
  String? pendingWallet;
  String? driverStatus;
  int? isDriver;
  int? isOnline;
  int? serviceId;
  String? token;
  String? gender;
  int? rewardPoints;
  int? cashRestrictionSecondsRemaining;
  bool? isVip;
  VipThemeModel? vipTheme;
  ActivePackage? activePackage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['image'] = image;
    map['country_id'] = countryId;
    map['city'] = city;
    map['email'] = email;
    map['wallet_amount'] = walletAmount;
    map['pending_wallet'] = pendingWallet;
    map['driver_status'] = driverStatus;
    map['is_driver'] = isDriver;
    map['is_online'] = isOnline;
    map['service_id'] = serviceId;
    map['token'] = token;
    map['gender'] = gender;
    map['reward_points'] = rewardPoints;
    map['cash_restriction_seconds_remaining'] = cashRestrictionSecondsRemaining;
    map['is_vip'] = isVip;
    if (vipTheme != null) {
      map['vip_theme'] = vipTheme!.toJson();
    }
    if (activePackage != null) {
      map['active_package'] = activePackage!.toJson();
    }
    return map;
  }
}

class VipThemeModel extends VipThemeEntity {
  VipThemeModel({
    required super.isVip,
    super.badgeTitle,
    super.primaryColor,
    super.showGoldFrame,
  });

  factory VipThemeModel.fromJson(Map<String, dynamic> json) {
    return VipThemeModel(
      isVip: json['is_vip'] == true || json['is_vip'] == 1,
      badgeTitle: json['badge_title']?.toString(),
      primaryColor: json['primary_color']?.toString(),
      showGoldFrame: json['show_gold_frame'] == true || json['show_gold_frame'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_vip': isVip,
      'badge_title': badgeTitle,
      'primary_color': primaryColor,
      'show_gold_frame': showGoldFrame,
    };
  }
}

class ActivePackageModel extends ActivePackage {
  ActivePackageModel({required super.id, required super.name, super.image, super.expiresAt});

  factory ActivePackageModel.fromJson(Map<String, dynamic> json) {
    return ActivePackageModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      expiresAt: json['expires_at']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'expires_at': expiresAt,
    };
  }
}
