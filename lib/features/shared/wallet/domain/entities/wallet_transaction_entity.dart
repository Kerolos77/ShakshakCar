class WalletTransactionEntity {
  final int? id;
  final String? paymentId;
  final String? status;
  final int? success;
  final String? amount;
  final String? paymentMethod;
  final String? paymentGateway;
  final int? userID;
  final String? createdAt;
  final String? updatedAt;
  final String? type;
  final dynamic note;

  WalletTransactionEntity({
    this.id,
    this.paymentId,
    this.status,
    this.success,
    this.amount,
    this.paymentMethod,
    this.paymentGateway,
    this.userID,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.note,
  });
}
