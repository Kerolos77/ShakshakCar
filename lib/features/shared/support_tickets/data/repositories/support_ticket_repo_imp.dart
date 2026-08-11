import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/support_tickets/data/models/support_ticket_model.dart';
import 'package:shakshak/features/shared/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:shakshak/features/shared/support_tickets/domain/repositories/support_ticket_repo.dart';

class SupportTicketRepoImp implements SupportTicketRepo {
  @override
  Future<Either<Failure, List<SupportTicketEntity>>> getMyTickets() async {
    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);
      final response = await DioHelper.getData(
        url: ApiConstant.myTicketsUrl,
        token: token,
      );

      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        final data = response.data;
        List<dynamic> rawList = [];

        if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            rawList = data['data'];
          } else if (data['tickets'] is List) {
            rawList = data['tickets'];
          }
        } else if (data is List) {
          rawList = data;
        }

        final List<SupportTicketEntity> tickets = rawList
            .whereType<Map<String, dynamic>>()
            .map((item) => SupportTicketModel.fromJson(item))
            .toList();

        return right(tickets);
      }
      return right([]);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> createTicket({
    required String subject,
    required String description,
    int? orderId,
    String priority = 'medium',
  }) async {
    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);
      final body = <String, dynamic>{
        'subject': subject,
        'description': description,
        'priority': priority,
      };
      if (orderId != null) {
        body['order_id'] = orderId;
      }

      final response = await DioHelper.postData(
        url: ApiConstant.createTicketUrl,
        token: token,
        data: body,
      );

      if (response != null && response.data != null) {
        final resData = response.data;
        Map<String, dynamic>? ticketJson;

        if (resData is Map<String, dynamic>) {
          if (resData['data'] is Map<String, dynamic>) {
            ticketJson = resData['data'];
          } else if (resData['ticket'] is Map<String, dynamic>) {
            ticketJson = resData['ticket'];
          } else {
            ticketJson = resData;
          }
        }

        if (ticketJson != null) {
          return right(SupportTicketModel.fromJson(ticketJson));
        }
      }
      return left(ServerFailure('تعذر إنشاء التكيت'));
    } catch (e) {
      if (e is DioException) {
        final msg = e.response?.data is Map &&
                e.response?.data['message'] != null
            ? e.response?.data['message']
            : 'حدث خطأ أثناء إرسال التكيت';
        return left(ServerFailure(msg));
      }
      return left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
