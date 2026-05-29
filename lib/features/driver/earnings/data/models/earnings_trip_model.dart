class EarningsTripModel {
  final int id;
  final String? completedAt;
  final String userName;
  final String serviceTitle;
  final double grossEarnings;
  final double netEarnings;
  final double commission;
  final PaymentBreakdown paymentBreakdown;

  EarningsTripModel({
    required this.id,
    this.completedAt,
    required this.userName,
    required this.serviceTitle,
    required this.grossEarnings,
    required this.netEarnings,
    required this.commission,
    required this.paymentBreakdown,
  });

  factory EarningsTripModel.fromJson(Map<String, dynamic> json) {
    return EarningsTripModel(
      id: json['id'],
      completedAt: json['completed_at'],
      userName: json['user_name'] ?? '',
      serviceTitle: json['service_title'] ?? '',
      grossEarnings: (json['gross_earnings'] ?? 0).toDouble(),
      netEarnings: (json['net_earnings'] ?? 0).toDouble(),
      commission: (json['commission'] ?? 0).toDouble(),
      paymentBreakdown: PaymentBreakdown.fromJson(json['payment_breakdown'] ?? {}),
    );
  }
}

class PaymentBreakdown {
  final double cash;
  final double digital;
  final String paymentType;

  PaymentBreakdown({
    required this.cash,
    required this.digital,
    required this.paymentType,
  });

  factory PaymentBreakdown.fromJson(Map<String, dynamic> json) {
    return PaymentBreakdown(
      cash: (json['cash'] ?? 0).toDouble(),
      digital: (json['digital'] ?? 0).toDouble(),
      paymentType: json['payment_type'] ?? '',
    );
  }
}
