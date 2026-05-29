import 'package:shakshak/features/shared/wallet/domain/entities/charge_wallet_entity.dart';

class ChargeWalletModel extends ChargeWalletEntity {
  ChargeWalletModel({
    super.data,
    super.msg,
    super.status,
    super.statusval,
  });

  ChargeWalletModel.fromJson(dynamic json)
      : super(
          data: json['data'],
          msg: json['msg'],
          status: json['status'],
          statusval: json['statusval'],
        );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    map['msg'] = msg;
    map['status'] = status;
    map['statusval'] = statusval;
    return map;
  }
}
