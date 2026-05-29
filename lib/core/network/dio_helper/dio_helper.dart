import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';

class DioHelper {
  static Dio? dio;
  static String logName = "DIO HELPER Request Data";
  static int requestId = 0;
  static String tag = '';

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      receiveDataWhenStatusError: true,
    ));

    // Manual interceptor
    dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        requestId++;
        tag = "$logName $requestId";
        debugPrint("NEW REQUEST$tag");
        dev.log(
          '''
============================================
🚀 REQUEST
URL: ${options.baseUrl}${options.path}
METHOD: ${options.method}
HEADERS: ${options.headers}
QUERY: ${options.queryParameters}
BODY: ${options.data}
============================================
''',
          name: tag,
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        dev.log(
          '''
============================================
✅ RESPONSE
STATUS: ${response.statusCode}
DATA: ${response.data}
============================================
''',
          name: tag,
        );
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        dev.log(
          '''
============================================
❌ ERROR
MESSAGE: ${e.message}
TYPE: ${e.type}
STATUS: ${e.response?.statusCode}
DATA: ${e.response?.data}
============================================
''',
          name: tag,
          error: e,
          stackTrace: e.stackTrace,
        );

        return handler.next(e);
      },
    ));

    // Pretty logger
    dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    String? lang,
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': AppConstant.currentLanguage,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio!.get(
      url,
      queryParameters: query,
      data: body,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  static Future<Response> getDataWithoutToken({
    required String url,
    Map<String, dynamic>? query,
    String? lang,
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': AppConstant.currentLanguage,
      'Content-Type': 'application/json',
    };
    return await dio!.get(
      url,
      queryParameters: query,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Object data,
    String? token,
  }) async {
    dio!.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'lang': AppConstant.currentLanguage,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
  }

  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? query,
    required Object data,
    String? lang,
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': AppConstant.currentLanguage,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio!.patch(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String? lang,
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': AppConstant.currentLanguage,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio!.delete(
      url,
      queryParameters: query,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  static Future<Response> postDataWithoutToken({
    required String url,
    Map<String, dynamic>? query,
    Object? data,
    String? lang,
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': AppConstant.currentLanguage,
      'Authorization': token == null ? '' : 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? lang,
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': AppConstant.currentLanguage,
      'Authorization': (token != null && token.isNotEmpty) ? 'Bearer $token' : '',
      'Content-Type': 'application/json',
    };
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
}
