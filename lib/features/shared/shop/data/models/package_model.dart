class ShopResponseModel {
  final bool success;
  final ShopData? data;

  ShopResponseModel({required this.success, this.data});

  factory ShopResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? ShopData.fromJson(json['data']) : null,
    );
  }
}

class ShopData {
  final int points;
  final double? wallet;
  final PackageModel? activePackage;
  final List<PackageModel> packages;

  ShopData({
    required this.points, 
    this.wallet,
    this.activePackage,
    required this.packages
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      points: json['points'] ?? 0,
      wallet: json['wallet'] != null ? double.tryParse(json['wallet'].toString()) : null,
      activePackage: json['active_package'] != null ? PackageModel.fromJson(json['active_package']) : null,
      packages: (json['packages'] as List?)
              ?.map((e) => PackageModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PackageModel {
  final int id;
  final String name;
  final String? description;
  final int durationHours;
  final double discountPercentage;
  final int pricePoints;
  final double priceCash;
  final String? imageUrl;
  final String userType;

  PackageModel({
    required this.id,
    required this.name,
    this.description,
    required this.durationHours,
    required this.discountPercentage,
    required this.pricePoints,
    required this.priceCash,
    this.imageUrl,
    required this.userType,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      name: json['name'] ?? '',
      description: json['description'],
      durationHours: json['duration_hours'] is int 
          ? json['duration_hours'] 
          : (int.tryParse(json['duration_hours']?.toString() ?? '0') ?? 0),
      discountPercentage: double.tryParse(json['discount_percentage']?.toString() ?? '0') ?? 0.0,
      pricePoints: json['price_points'] is int 
          ? json['price_points'] 
          : (int.tryParse(json['price_points']?.toString() ?? '0') ?? 0),
      priceCash: double.tryParse(json['price_cash']?.toString() ?? '0') ?? 0.0,
      imageUrl: json['image_url'],
      userType: json['user_type'] ?? 'driver',
    );
  }
}
