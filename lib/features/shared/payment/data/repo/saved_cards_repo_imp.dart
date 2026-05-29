import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/payment/data/models/saved_card_model.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';
import 'package:shakshak/features/shared/payment/domain/repositories/saved_cards_repo.dart';
import 'package:shakshak/features/shared/payment/domain/entities/add_card_intent_entity.dart';
import 'package:shakshak/features/shared/payment/data/models/add_card_intent_model.dart';

class SavedCardsRepoImp implements SavedCardsRepo {
  @override
  Future<Either<Failure, List<SavedCardEntity>>> getSavedCards() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.savedCardsUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );

      List<SavedCardEntity> cards = [];
      if (data.data['data'] is List) {
        cards = (data.data['data'] as List)
            .map((e) => SavedCardModel.fromJson(e))
            .toList();
      }
      return right(cards);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> payWithSavedCard({
    required int savedCardId,
    required double amount,
    required int orderId,
  }) async {
    try {
      await DioHelper.postData(
        url: ApiConstant.payWithSavedCardUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'saved_card_id': savedCardId,
          'amount': amount,
          'order_id': orderId,
        },
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddCardIntentEntity>> addCard() async {
    try {
      var data = await DioHelper.postData(
        url: ApiConstant.addCardUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {}, // Usually paymob add-card endpoints might require no body, or some identifiers. Providing empty mapping.
      );

      return right(AddCardIntentModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCard({required String cardId}) async {
    try {
      await DioHelper.deleteData(
        url: '${ApiConstant.savedCardsUrl}/$cardId',
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> payWithSavedCardForWallet({
    required int savedCardId,
    required double amount,
  }) async {
    try {
      await DioHelper.postData(
        url: ApiConstant.payWithSavedCardUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'saved_card_id': savedCardId,
          'amount': amount,
        },
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddCardIntentEntity>> chargeWalletWithNewCard({
    required double amount,
  }) async {
    try {
      var data = await DioHelper.postData(
        url: ApiConstant.chargeWalletPaymobUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'amount': amount,
          'save_card': true,
        },
      );
      return right(AddCardIntentModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
