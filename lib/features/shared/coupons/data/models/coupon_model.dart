import 'package:shakshak/features/shared/coupons/domain/entities/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    required super.id,
    required super.title,
    required super.description,
    required super.code,
    super.discountText,
    super.minSpend,
    super.expiryDate,
    super.imageUrl,
    super.isExpired = false,
    super.isUsed = false,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedExpiry;
    final expStr = json['expiry_date'] ??
        json['expiryDate'] ??
        json['expires_at'] ??
        json['valid_until'] ??
        json['end_date'];
    if (expStr != null) {
      parsedExpiry = DateTime.tryParse(expStr.toString());
    }

    bool isExpired = json['is_expired'] == true ||
        json['expired'] == true ||
        (parsedExpiry != null && parsedExpiry.isBefore(DateTime.now()));

    bool isUsed = json['is_used'] == true ||
        json['used'] == true ||
        json['status'] == 'used';

    double? minSpendVal;
    final minSpendRaw = json['min_spend'] ?? json['minimum_spend'] ?? json['min_order_amount'] ?? json['min_order'];
    if (minSpendRaw != null) {
      minSpendVal = double.tryParse(minSpendRaw.toString());
    }

    String discountText = json['discountText'] ??
        json['discount_text'] ??
        json['discount']?.toString() ??
        '';

    final type = json['type']?.toString();
    final val = json['value'];

    if (discountText.isEmpty && val != null) {
      if (type == 'percentage') {
        discountText = 'خصم $val%';
      } else if (type == 'fixed') {
        discountText = '$val ج.م خصم';
      } else {
        discountText = 'خصم $val';
      }
    } else if (discountText.isEmpty && json['discount_percentage'] != null) {
      discountText = 'خصم ${json['discount_percentage']}%';
    } else if (discountText.isEmpty && json['discount_amount'] != null) {
      discountText = '${json['discount_amount']} ج.م خصم';
    }

    return CouponModel(
      id: json['id']?.toString() ?? json['coupon_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? json['name'] ?? json['headline'] ?? 'كوبون خصم',
      description: json['description'] ?? json['details'] ?? json['body'] ?? '',
      code: json['code'] ?? json['coupon_code'] ?? json['promo_code'] ?? 'SHAKSHAK',
      discountText: discountText.isNotEmpty ? discountText : null,
      minSpend: minSpendVal,
      expiryDate: parsedExpiry,
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? json['image'] ?? json['picture'],
      isExpired: isExpired,
      isUsed: isUsed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'code': code,
      'discount_text': discountText,
      'min_spend': minSpend,
      'expiry_date': expiryDate?.toIso8601String(),
      'image_url': imageUrl,
      'is_expired': isExpired,
      'is_used': isUsed,
    };
  }
}
