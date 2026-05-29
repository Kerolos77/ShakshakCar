import 'package:shakshak/features/shared/shop/data/models/package_model.dart';

class SubscriptionStatusModel {
  final bool success;
  final SubscriptionData? data;

  SubscriptionStatusModel({required this.success, this.data});

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? SubscriptionData.fromJson(json['data']) : null,
    );
  }
}

class SubscriptionData {
  final bool isSubscribed;
  final int points;
  final double? wallet;
  final String? message;
  final SubscriptionDetails? subscription;

  SubscriptionData({
    required this.isSubscribed,
    required this.points,
    this.wallet,
    this.message,
    this.subscription,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    // If 'subscription' key is missing, try to see if 'active_package' exists (different API structures)
    final hasSubscription = json['subscription'] != null || json['active_package'] != null;
    
    return SubscriptionData(
      isSubscribed: json['is_subscribed'] ?? hasSubscription,
      points: json['points'] ?? 0,
      wallet: json['wallet'] != null ? double.tryParse(json['wallet'].toString()) : null,
      message: json['message'],
      subscription: json['subscription'] != null 
          ? SubscriptionDetails.fromJson(json['subscription']) 
          : null,
    );
  }
}

class SubscriptionDetails {
  final int purchaseId;
  final String expiresAt;
  final int daysRemaining;
  final int hoursRemaining;
  final PackageModel package;

  SubscriptionDetails({
    required this.purchaseId,
    required this.expiresAt,
    required this.daysRemaining,
    required this.hoursRemaining,
    required this.package,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      purchaseId: json['purchase_id'],
      expiresAt: json['expires_at'],
      daysRemaining: json['days_remaining'] ?? 0,
      hoursRemaining: json['hours_remaining'] ?? 0,
      package: PackageModel.fromJson(json['package']),
    );
  }
}
