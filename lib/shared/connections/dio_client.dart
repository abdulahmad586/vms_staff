import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shevarms_user/shared/constant/constant.dart';

const _defaultConnectTimeout = Duration(seconds: 10);
const _defaultReceiveTimeout = Duration(seconds: 10);

class DioClient {
  String baseUrl = ApiConstants.baseUrl;
  Dio? _dio;
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio();
    _dio!
      ..options.baseUrl = baseUrl
      ..options.followRedirects = true
      ..options.validateStatus = (status) {
        return status != null && status < 500;
      }
      ..options.connectTimeout = _defaultConnectTimeout.inMilliseconds
      ..options.receiveTimeout = _defaultReceiveTimeout.inMilliseconds
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

    if (kDebugMode) {
      _dio!.interceptors.add(
        LogInterceptor(
            responseBody: true,
            error: true,
            requestHeader: false,
            responseHeader: false,
            request: false,
            requestBody: false),
      );
    }

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.data is String) {
          print(response.data);
          throw "Bad response received";
        }
        return handler.next(response);
      },
      onError: (error, handler) async {
        return handler.next(error);
      },
    ));
  }

  initToken(String token) {
    _dio?.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-token': token
    };
  }

  initBaseUrl(String url) {
    _dio?.options.baseUrl = url;
    // print("Updated base url to $url ${_dio?.options.baseUrl}");
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      throw determineErrorMessage(e);
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      throw determineErrorMessage(e);
    }
  }

  Future<dynamic> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio!.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      throw determineErrorMessage(e);
    }
  }

  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      throw determineErrorMessage(e);
    }
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      throw determineErrorMessage(e);
    }
  }

  String determineErrorMessage(Object e) {
    String message = "An unknown error occurred";
    print(e);
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          message = "Connection timed out, please try again";
          break;
        case DioErrorType.sendTimeout:
          message = "Connection timed out, please try again";
          break;
        case DioErrorType.receiveTimeout:
          message = "Connection timed out, please try again";
          break;
        case DioErrorType.response:
          message =
              e.response?.data?['message'] ?? "Invalid response from server";
          break;
        case DioErrorType.cancel:
          message = "Request was canceled";
          break;
        case DioErrorType.other:
          message = e.message;
          break;
      }
      return message;
    }
    return e.toString();
  }
}
