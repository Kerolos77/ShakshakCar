// import 'package:dio/dio.dart';
//
// class TestDio {
//   static late Dio dio;
//
//   static init() {
//     dio = Dio(BaseOptions(
//       baseUrl: "",
//     ));
//   }
//
//   static Future<Response> getData({
//     required String url,
//     Map<String, dynamic>? query,
//     String? token,
//   }) async {
//     try {
//       dio.options.headers = {
//         'Content-Type': 'application/json',
//         'Authorization': token ?? '',
//       };
//       return await dio.get(url, queryParameters: query);
//     } catch (e) {}
//   }
// }
