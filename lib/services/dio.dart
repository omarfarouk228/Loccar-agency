import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/preferences.dart';
import 'package:logging/logging.dart';

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();
  factory DioHelper() => _instance;

  late Dio _dio;
  final Logger _logger = Logger('NetworkLogger');

  static const String _tokenKey = 'auth_token';

  DioHelper._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    // Configure base options
    BaseOptions options = BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors
    _dio.interceptors.addAll([
      _LoggingInterceptor(_logger),
      _AuthInterceptor(),
    ]);
  }

  // Save token after login
  Future<void> saveToken(String token) async {
    await SharedPreferencesHelper.setValue(_tokenKey, token);

    _logger.info('Token saved successfully');
  }

  // Remove token on logout
  Future<void> removeToken() async {
    await SharedPreferencesHelper.deleteValue(_tokenKey);
    _logger.info('Token removed');
  }

  // Get saved token
  Future<String?> getToken() async {
    return await SharedPreferencesHelper.getValue(_tokenKey);
  }

  // Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      debugPrint("Request url: $path");
      debugPrint("Query parameters: ${queryParameters ?? {}}");
      return await _dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _logger.severe('GET request error', e);
      rethrow;
    }
  }

  // Generic POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      debugPrint("Request url: $path");
      debugPrint("Query parameters: ${queryParameters ?? {}}");
      debugPrint("Data: ${data ?? {}}");
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      debugPrint("DioException status code: ${e.response?.statusCode}");
      debugPrint("DioException response data: ${e.response?.data}");
      debugPrint("DioException headers: ${e.response?.headers}");
      debugPrint("DioException message: ${e.message}");
      _logger.severe('POST request error', e);
      rethrow;
    }
  }

  // Generic PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      debugPrint("Request url: $path");
      debugPrint("Query parameters: ${queryParameters ?? {}}");
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _logger.severe('PUT request error', e);
      rethrow;
    }
  }

  // Generic DELETE request
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      debugPrint("Request url: $path");
      debugPrint("Query parameters: ${queryParameters ?? {}}");
      return await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _logger.severe('DELETE request error', e);
      rethrow;
    }
  }
}

class _LoggingInterceptor extends Interceptor {
  final Logger logger;

  _LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.info('''
    *** Request Log ***
    URL: ${options.path}
    Method: ${options.method}
    Headers: ${options.headers}
    Data: ${options.data}
    ''');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.info('''
    *** Response Log ***
    Status Code: ${response.statusCode}
    Data: ${response.data}
    ''');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.severe('''
    *** Error Log ***
    Message: ${err.message}
    Response: ${err.response}
    ''');
    super.onError(err, handler);
  }
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SharedPreferencesHelper.getValue('auth_token');

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
