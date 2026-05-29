class PointTransactionModel {
  final int id;
  final int userId;
  final int amount;
  final String description;
  final int? orderId;
  final DateTime createdAt;

  PointTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    this.orderId,
    required this.createdAt,
  });

  factory PointTransactionModel.fromJson(Map<String, dynamic> json) {
    return PointTransactionModel(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      description: json['description'],
      orderId: json['order_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class PointsHistoryResponse {
  final int currentPoints;
  final List<PointTransactionModel> transactions;
  final bool status;

  PointsHistoryResponse({
    required this.currentPoints,
    required this.transactions,
    required this.status,
  });

  factory PointsHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PointsHistoryResponse(
      currentPoints: json['data']?['current_points'] ?? 0,
      status: json['statusval'] ?? false,
      transactions: (json['data']?['transactions'] as List?)
              ?.map((e) => PointTransactionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
