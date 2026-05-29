import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response?.statusCode, dioError.response?.data);

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');

      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceled');

      case DioExceptionType.connectionError:
        return ServerFailure('connection error');

      case DioExceptionType.unknown:
        if ((dioError.message ?? '').contains('SocketException')) {
          return ServerFailure('No Internet Connection');
        }

        return ServerFailure('Unexpected Error, Please try again!');

      default:
        return ServerFailure('Oops There was an Error, Please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || (statusCode == 200 && response['statusval'] == false)) {
      if (response['data'] != null &&
          response['data']['active_order_ids'] != null &&
          (response['data']['active_order_ids'] as List).isNotEmpty) {
        return ActiveTripFailure(
          response['msg'] ?? 'You have an active trip',
          (response['data']['active_order_ids'] as List).first,
        );
      }
      return ServerFailure(response['msg'] ?? response['message'] ?? 'Error');
    } else if (statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['msg'] ?? response['message'] ?? 'Error');
    } else if (statusCode == 402) {
      return PaymentRequiredFailure(
          response['msg'] ?? response['message'] ?? 'Payment Required',
          response['data']);
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try later!');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server error, Please try later');
    } else {
      return ServerFailure('Oops There was an Error, Please try again');
    }
  }
}

class PaymentRequiredFailure extends ServerFailure {
  final dynamic data;
  PaymentRequiredFailure(super.message, this.data);
}

class ActiveTripFailure extends ServerFailure {
  final int activeOrderId;
  ActiveTripFailure(super.message, this.activeOrderId);
}
