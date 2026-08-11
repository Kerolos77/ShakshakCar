class CouponEntity {
  final String id;
  final String title;
  final String description;
  final String code;
  final String? discountText;
  final double? minSpend;
  final DateTime? expiryDate;
  final String? imageUrl;
  final bool isExpired;
  final bool isUsed;

  const CouponEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    this.discountText,
    this.minSpend,
    this.expiryDate,
    this.imageUrl,
    this.isExpired = false,
    this.isUsed = false,
  });
}
