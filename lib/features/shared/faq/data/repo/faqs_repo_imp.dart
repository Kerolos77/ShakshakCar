import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/shared/faq/data/models/faqs_model.dart';
import 'package:shakshak/features/shared/faq/domain/entities/faqs_entity.dart';
import 'package:shakshak/features/shared/faq/domain/repositories/faqs_repo.dart';

class FaqsRepoImp implements FaqsRepo {
  @override
  Future<Either<Failure, FaqsEntity>> getFaqs() async {
    try {
      var data = await DioHelper.getData(
        url: ApiConstant.getFaqsUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return right(FaqsModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
