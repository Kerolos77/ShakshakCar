import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/rides/domain/repositories/rides_repo.dart';
import 'package:shakshak/features/shared/rides/domain/entities/rides_entity.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/shared/rides/data/models/rides_model.dart';

class RidesRepoImp implements RidesRepo {
  @override
  Future<Either<Failure, RidesEntity>> getRides({
    int? inCity,
    bool isDriver = false,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (inCity != null) {
        queryParams['in_city'] = inCity;
      }
      
      var data = await DioHelper.getData(
          url: isDriver
              ? ApiConstant.orderOldForDriver
              : ApiConstant.getUserRidesUrl,
          token: CacheHelper.getData(key: AppConstant.kToken),
          query: queryParams);
      debugPrint('=== RIDES API RAW RESPONSE ===');
      debugPrint('data.data type: ${data.data.runtimeType}');
      if (data.data is Map) {
        final d = data.data as Map;
        debugPrint('Top-level keys: ${d.keys.toList()}');
        if (d['data'] != null) {
          debugPrint('data["data"] type: ${d['data'].runtimeType}');
          if (d['data'] is Map) {
            debugPrint('data["data"] keys: ${(d['data'] as Map).keys.toList()}');
          }
        }
      }
      debugPrint('==============================');
      return right(RideModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
