// import 'package:dio/dio.dart';
// import 'package:proo/core/network/api_result.dart';
// import 'package:proo/features/user/user_home_page/data/models/calc_price_time_distance_request_body.dart';
// import 'package:proo/features/user/user_home_page/data/models/cancel_ride_request_body.dart';
//
// import 'package:shakshak/core/network/network_exceptions.dart';
// import 'package:shakshak/core/network/web_services.dart';
// import '../../../../../../../auth/registration_screen/driver/data/models/category_of_vehicle_response.dart';
// import 'package:shakshak/features/user/user_home_page/data/models/request_ride_request_body.dart';
//
// class UserHomeRepository {
//   final AppWebServices appWebServices;
//
//   UserHomeRepository(this.appWebServices);
//
//   Future<ApiResult<dynamic>> calcPriceAndTimeDistance(
//       {required CalcPriceTimeDistanceRequestBody
//           calcPriceTimeDistanceRequestBody}) async {
//     try {
//       final response = await appWebServices
//           .calcPriceAndTimeDistance(calcPriceTimeDistanceRequestBody);
//       return ApiResult.success(response);
//     } on DioError catch (e) {
//       return ApiResult.failure(NetworkExceptions.getDioException(e));
//     } catch (e) {
//       return ApiResult.failure(NetworkExceptions.getDioException(e));
//     }
//   }
//
//   Future<ApiResult<CategoryOfVehicleResponse>> getCategoryOfVehicle() async {
//     try {
//       // Fetch the response from the API
//       final response = await appWebServices.getCategoryOfVehicle();
//       // Parse the response into a CategoryOfVehicleResponse object
//       CategoryOfVehicleResponse categoryOfVehicleResponse =
//       CategoryOfVehicleResponse.fromJson(response);
//
//       return ApiResult.success(categoryOfVehicleResponse);
//     } catch (e) {
//       print(e.toString());
//       // Handle the exception and return failure
//       return ApiResult.failure(NetworkExceptions.getDioException(e));
//     }
//   }
//
//
//   Future<ApiResult<dynamic>> requestRide(
//       {required RequestRideRequestBody requestRideRequestBody}) async {
//     try {
//       final response = await appWebServices.requestRide(requestRideRequestBody);
//       return ApiResult.success(response);
//     } on DioError catch (e) {
//       return ApiResult.failure(NetworkExceptions.getDioException(e));
//     } catch (e) {
//       return ApiResult.failure(NetworkExceptions.getDioException(e));
//     }
//   }
//   Future<ApiResult<dynamic>> cancelRideRequestByPassenger(
//       {required CancelRideRequestBody cancelRideRequestBody}) async {
//     try {
//       final response = await appWebServices.cancelRideRequestByPassenger(cancelRideRequestBody);
//       return ApiResult.success(response);
//     } on DioError catch (e) {
//       return ApiResult.failure(NetworkExceptions.getDioException(e));
//     } catch (e) {
//       return ApiResult.failure(NetworkExceptions.getDioException(e));
//     }
//   }
// }


