import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/rides/data/models/rides_model.dart';
import 'package:shakshak/features/shared/rides/domain/entities/rides_entity.dart';
import 'package:shakshak/features/shared/rides/domain/repositories/rides_repo.dart';

class RidesRepoImp implements RidesRepo {
  static RidesEntity? _cachedUserRides;
  static RidesEntity? _cachedDriverRides;

  /// Clear in-memory rides cache (e.g. on logout or new ride creation)
  static void clearCache() {
    _cachedUserRides = null;
    _cachedDriverRides = null;
  }

  @override
  Future<Either<Failure, RidesEntity>> getRides({
    int? inCity,
    bool isDriver = false,
  }) async {
    final cached = isDriver ? _cachedDriverRides : _cachedUserRides;

    if (cached != null) {
      // Return cached instantly for zero-latency UI response,
      // and refresh in background to keep data updated
      _fetchRidesFromApi(inCity: inCity, isDriver: isDriver).then((_) {});
      return right(cached);
    }

    return await _fetchRidesFromApi(inCity: inCity, isDriver: isDriver);
  }

  Future<Either<Failure, RidesEntity>> _fetchRidesFromApi({
    int? inCity,
    required bool isDriver,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (inCity != null) {
        queryParams['in_city'] = inCity;
      }

      var response = await DioHelper.getData(
        url: isDriver
            ? ApiConstant.orderOldForDriver
            : ApiConstant.getUserRidesUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        query: queryParams,
      );

      final model = RideModel.fromJson(response.data);
      if (isDriver) {
        _cachedDriverRides = model;
      } else {
        _cachedUserRides = model;
      }

      return right(model);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
