import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/driver/home/data/models/driver_toggle_online_model.dart';
import 'package:shakshak/features/driver/home/data/models/demand_map_model.dart';

import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/driver/home/domain/entities/driver_toggle_online_entity.dart';
import 'package:shakshak/features/driver/home/domain/repositories/driver_home_repo.dart';

class DriverHomeRepoImp implements DriverHomeRepo {
  @override
  Future<Either<Failure, DriverToggleOnlineEntity>> driverToggleOnline(
      {required int value}) async {
    try {
      var data = await DioHelper.getData(
        url: '${ApiConstant.driverToggleOnlineUrl}/$value',
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(DriverToggleOnlineModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DemandMapModel>> getDemandMap() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.demandMapUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(DemandMapModel.fromJson(data.data['data']));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> driverSetDestination({
    required bool isHeadingDestination,
    double? lat,
    double? lng,
    String? address,
  }) async {
    try {
      var response = await DioHelper.postData(
        url: ApiConstant.driverSetDestinationUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'is_heading_destination': isHeadingDestination,
          'destination_lat': lat,
          'destination_long': lng,
          'destination_address': address,
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
