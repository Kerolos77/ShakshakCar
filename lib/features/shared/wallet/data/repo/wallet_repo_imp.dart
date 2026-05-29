import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/wallet/data/models/charge_wallet_model.dart';
import 'package:shakshak/features/shared/wallet/data/models/wallet_transactions_model.dart';
import 'package:shakshak/features/shared/wallet/domain/repositories/wallet_repo.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/charge_wallet_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transactions_response_entity.dart';

import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';

class WalletRepoImp implements WalletRepo {
  @override
  Future<Either<Failure, WalletTransactionsResponseEntity>>
      getWalletTransactions() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.getWalletTransactionsUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(WalletTransactionsModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChargeWalletEntity>> chargeWallet(
      {required double value}) async {
    try {
      var data = await DioHelper.getData(
          url: ApiConstant.chargeWalletUrl,
          token: CacheHelper.getData(key: AppConstant.kToken),
          query: {
            'value': value,
          });
      return right(ChargeWalletModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletTransactionsResponseEntity>> withdrawRequest({
    required double amount,
    String? note,
  }) async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.withdrawRequestUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        query: {
          'amount': amount,
          if (note != null) 'note': note,
        },
      );
      return right(WalletTransactionsModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
