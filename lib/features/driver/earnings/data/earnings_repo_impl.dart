import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

import '../../../../core/error/failure.dart';
import 'earnings_repo.dart';
import 'models/earnings_summary_model.dart';
import 'models/earnings_trip_model.dart';

class EarningsRepoImpl implements EarningsRepo {
  @override
  Future<Either<Failure, EarningsSummaryModel>> getSummary({
    required String period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = CacheHelper.getData(key: 'token');
      final response = await DioHelper.getData(
        url: ApiConstant.driverEarningsSummaryUrl,
        token: token,
        query: {
          'period': period,
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );

      if (response.statusCode == 200) {
        return Right(EarningsSummaryModel.fromJson(response.data['data']));
      } else {
        return Left(ServerFailure(
            response.data['message'] ?? 'Error fetching summary'));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EarningsTripModel>>> getHistory({
    required String period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = CacheHelper.getData(key: 'token');
      final response = await DioHelper.getData(
        url: ApiConstant.driverEarningsHistoryUrl,
        token: token,
        query: {
          'period': period,
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );

      if (response.statusCode == 200) {
        final List trips = response.data['data'];
        return Right(trips.map((e) => EarningsTripModel.fromJson(e)).toList());
      } else {
        return Left(ServerFailure(
            response.data['message'] ?? 'Error fetching history'));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
