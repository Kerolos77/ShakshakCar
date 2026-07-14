import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/driver/new_rides/domain/repositories/new_ride_repo.dart';
import 'package:shakshak/features/driver/new_rides/domain/entities/negotiation_settings_entity.dart';
import 'package:shakshak/features/driver/new_rides/data/models/negotiation_settings_model.dart';

class NewRideRepoImp implements NewRideRepo {
  @override
  Future<Either<Failure, List<NewRideData>>> fetchNewRides() async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.getData(
        url: ApiConstant.orderOldForDriver,
        token: token,
      );

      List<NewRideData> allRides = [];

      if (response.data != null && response.data['data'] != null) {
        final dataMap = response.data['data'];

        // 1. استخلاص الرحلات من "searching"
        if (dataMap['searching'] is List) {
          allRides.addAll((dataMap['searching'] as List)
              .map((ride) => NewRideData.fromJson(ride)));
        }

        // 2. استخلاص الرحلات من "placed" (إذا كانت موجودة وتعني طلبات جديدة)
        if (dataMap['placed'] is List) {
          allRides.addAll((dataMap['placed'] as List)
              .map((ride) => NewRideData.fromJson(ride)));
        }

        // 3. في حال كان الـ API يعود بقائمة مباشرة تحت "data"
        if (dataMap is List) {
          allRides.addAll(
              (dataMap as List).map((ride) => NewRideData.fromJson(ride)));
        }
      }

      return right(allRides);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptRide(int orderId) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.postData(
        url: ApiConstant.driverAcceptUserPriceUrl,
        token: token,
        data: {
          'order_id': orderId,
        },
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> counterOffer(
      int orderId, double offerRate) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.postData(
        url: ApiConstant.driverCounterOfferUrl,
        token: token,
        data: {
          'order_id': orderId,
          'offer_rate': offerRate,
        },
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NegotiationSettingsEntity>>
      fetchNegotiationSettings() async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.getData(
        url: ApiConstant.percentageIncreaseUrl,
        token: token,
      );

      if (response.statusCode == 200 && response.data != null) {
        return right(NegotiationSettingsModel.fromJson(response.data));
      }
      return left(ServerFailure('Failed to load settings'));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectRide(int orderId) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.postData(
        url: ApiConstant.rejectOrderUrl,
        token: token,
        data: {
          'order_id': orderId,
        },
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> arriveRide(int orderId) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.getData(
        url: 'order/arrived/$orderId',
        token: token,
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> startRide(int orderId) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.getData(
        url: 'order/start/$orderId',
        token: token,
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> completeRide(int orderId) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.getData(
        url: 'order/end/$orderId',
        token: token,
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelRide(int orderId) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.getData(
        url: 'order/cancel/$orderId',
        token: token,
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPickupOtp(int orderId, String otp) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.postData(
        url: 'order/$orderId/verify-pickup-otp',
        token: token,
        data: {
          'pickup_otp': otp,
        },
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyDeliveryOtp(int orderId, String otp) async {
    try {
      final String token = CacheHelper.getData(key: AppConstant.kToken) ??
          ApiConstant.testDriverToken;

      var response = await DioHelper.postData(
        url: 'order/$orderId/verify-delivery-otp',
        token: token,
        data: {
          'delivery_otp': otp,
        },
      );

      return right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
