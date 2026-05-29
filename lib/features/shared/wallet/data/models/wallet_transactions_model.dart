import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transactions_response_entity.dart';

class WalletTransactionsModel extends WalletTransactionsResponseEntity {
  WalletTransactionsModel({
    super.data,
    super.msg,
    super.status,
    super.statusval,
  });

  factory WalletTransactionsModel.fromJson(dynamic json) {
    List<WalletTransactionData>? dataList;
    if (json['data'] != null) {
      dataList = [];
      json['data'].forEach((v) {
        dataList!.add(WalletTransactionData.fromJson(v));
      });
    }
    return WalletTransactionsModel(
      data: dataList,
      msg: json['msg'],
      status: json['status'],
      statusval: json['statusval'],
    );
  }
}

class WalletTransactionData extends WalletTransactionEntity {
  WalletTransactionData({
    super.id,
    super.paymentId,
    super.status,
    super.success,
    super.amount,
    super.paymentMethod,
    super.paymentGateway,
    super.userID,
    super.createdAt,
    super.updatedAt,
    super.type,
    super.note,
  });

  WalletTransactionData.fromJson(dynamic json)
      : super(
          id: json['id'],
          paymentId: json['payment_id'],
          status: json['status'],
          success: json['success'],
          amount: json['amount'],
          paymentMethod: json['payment_method'],
          paymentGateway: json['payment_gateway'],
          userID: json['userID'],
          createdAt: json['created_at'],
          updatedAt: json['updated_at'],
          type: json['type'],
          note: json['note'],
        );
}
