import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/rides/data/models/rides_model.dart';

import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_details_response_model.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_request_body_model.dart';
import 'package:shakshak/features/user/user_home/data/models/user_home_caption_model.dart';
import 'package:shakshak/features/user/user_home/domain/entities/user_home_caption_entity.dart';
import 'package:shakshak/features/user/user_home/domain/repositories/user_home_repo.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/user/user_home/data/models/accept_offer_model.dart';
import 'package:shakshak/features/user/user_home/data/models/price_model.dart';
import 'package:shakshak/features/user/user_home/data/models/services_model.dart';
import 'package:shakshak/features/user/user_home/domain/entities/accept_offer_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/price_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/services_entity.dart';
import 'package:shakshak/features/user/user_home/domain/entities/new_ride_data_entity.dart';

class UserHomeRepoImp implements UserHomeRepo {
  @override
  Future<Either<Failure, UserHomeCaptionEntity>> getCaptions() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.getCaptionsUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(UserHomeCaptionModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServicesEntity>> getInCityServices() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.getInCityServicesUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(ServicesModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServicesEntity>> getOutCityServices() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.getOutCityServicesUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(ServicesModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideModel>> getRides({required int inCity}) async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.getUserRidesUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        query: {'in_city': inCity},
      );
      return right(RideModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AcceptOfferEntity>> acceptOffer({
    required int offerId,
    required int driverId,
  }) async {
    try {
      var data = await DioHelper.postData(
        url: '${ApiConstant.acceptOfferUrl}/$offerId/accept',
        token: CacheHelper.getData(key: AppConstant.kToken),
        query: {'driver_id': driverId},
        data: {},
      );
      return right(AcceptOfferModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AcceptOfferEntity>> denyOffer({
    required int offerId,
  }) async {
    try {
      var data = await DioHelper.postData(
        url: '${ApiConstant.acceptOfferUrl}/$offerId/deny',
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {},
      );
      return right(AcceptOfferModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AcceptOfferEntity>> cancelOrder({
    required int orderId,
  }) async {
    try {
      var data = await DioHelper.getData(
        url: '${ApiConstant.cancelOrderUrl}/$orderId',
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(AcceptOfferModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PriceEntity>> getPrice({
    required int serviceId,
    required String origin,
    required String destination,
  }) async {
    try {
      var formData = FormData.fromMap({
        'service_id': serviceId,
        'origin': origin,
        'destination': destination,
      });

      var data = await DioHelper.postData(
        url: ApiConstant.getPrice,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: formData,
      );
      return right(PriceModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NewRideDataEntity>> newRideRequest({
    required NewRideRequestBodyModel newRideRequestBodyModel,
  }) async {
    try {
      var response = await DioHelper.postData(
        url: ApiConstant.orderNewUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: newRideRequestBodyModel.toJson(),
      );

      var responseData = response.data;
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      if (response.statusCode == 400 || responseData['statusval'] == false) {
        return left(ServerFailure.fromResponse(response.statusCode, responseData));
      }

      return right(NewRideDetailsResponse.fromJson(responseData).data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getNearbyDrivers({
    required double latitude,
    required double longitude,
  }) async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.nearbyDriversUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        query: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      return right(data.data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }

      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NewRideDataEntity>> getRideDetails({
    required int rideId,
  }) async {
    try {
      var response = await DioHelper.getData(
        url: ApiConstant.getOrderDetailsUrl(rideId),
        token: CacheHelper.getData(key: AppConstant.kToken),
      );

      var responseData = response.data;
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      return right(NewRideDetailsResponse.fromJson(responseData).data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, NewRideDataEntity>> getActiveRide() async {
    try {
      var response = await DioHelper.getData(
        url: ApiConstant.getActiveRideUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );

      var responseData = response.data;
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      return right(NewRideDetailsResponse.fromJson(responseData).data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
