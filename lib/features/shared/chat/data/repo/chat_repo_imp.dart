import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/shared/chat/data/models/send_message_model.dart';
import 'package:shakshak/features/shared/chat/domain/entities/send_message_entity.dart';
import 'package:shakshak/features/shared/chat/domain/repositories/chat_repo.dart';

class ChatRepoImp implements ChatRepo {
  @override
  Future<Either<Failure, SendMessageEntity>> sendMessage({
    required int tripId,
    required String message,
  }) async {
    try {
      var data = await DioHelper.getData(
          url: ApiConstant.sendMessageUrl,
          token: CacheHelper.getData(key: AppConstant.kToken),
          query: {
            'trip_id': tripId,
            'message': message,
          });
      return right(SendMessageModel.fromJson(data.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
