import 'package:appwrite/appwrite.dart' hide Response;
import 'package:dio/dio.dart';

import '../config/appwrite_config.dart';
import '../result/app_error.dart';
import '../result/result.dart';
import '../utils/app_logger.dart';
import '../../data/providers/appwrite_client_provider.dart';

class ApiClient {
  static const String _tag = 'ApiClient';

  final Dio _dio;
  final Account _account;

  String? _cachedJwt;
  DateTime? _jwtExpiry;

  ApiClient._({required Dio dio, required Account account})
      : _dio = dio,
        _account = account;

  factory ApiClient.init(
    AppwriteClientProvider clientProvider,
    AppwriteConfig config,
  ) {
    final dio = Dio(BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    final client = ApiClient._(dio: dio, account: clientProvider.account);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final jwt = await client._getJwt();
        if (jwt != null) {
          options.headers['Authorization'] = 'Bearer $jwt';
        }
        AppLogger.debug(
          '${options.method} ${options.path}',
          tag: _tag,
        );
        handler.next(options);
      },
      onError: (error, handler) {
        AppLogger.error(
          '${error.requestOptions.method} ${error.requestOptions.path} -> ${error.response?.statusCode}',
          tag: _tag,
          error: error,
        );
        handler.next(error);
      },
    ));

    return client;
  }

  Future<String?> _getJwt() async {
    if (_cachedJwt != null &&
        _jwtExpiry != null &&
        DateTime.now().isBefore(_jwtExpiry!)) {
      return _cachedJwt;
    }

    try {
      final jwt = await _account.createJWT();
      _cachedJwt = jwt.jwt;
      // Appwrite JWTs last 15 min; refresh at 13 min
      _jwtExpiry = DateTime.now().add(const Duration(minutes: 13));
      return _cachedJwt;
    } catch (e) {
      AppLogger.warning('JWT creation failed (guest?): $e', tag: _tag);
      _cachedJwt = null;
      _jwtExpiry = null;
      return null;
    }
  }

  void clearJwtCache() {
    _cachedJwt = null;
    _jwtExpiry = null;
  }

  // --------------- HTTP helpers ---------------

  Future<Result<Map<String, dynamic>, AppError>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e, st) {
      return Result.failure(_mapDioError(e, st));
    } catch (e, st) {
      return Result.failure(UnknownError(originalError: e, stackTrace: st));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(path,
          data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e, st) {
      return Result.failure(_mapDioError(e, st));
    } catch (e, st) {
      return Result.failure(UnknownError(originalError: e, stackTrace: st));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(path,
          data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e, st) {
      return Result.failure(_mapDioError(e, st));
    } catch (e, st) {
      return Result.failure(UnknownError(originalError: e, stackTrace: st));
    }
  }

  Future<Result<Map<String, dynamic>, AppError>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await _dio.delete(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e, st) {
      return Result.failure(_mapDioError(e, st));
    } catch (e, st) {
      return Result.failure(UnknownError(originalError: e, stackTrace: st));
    }
  }

  // --------------- Response parsing ---------------

  Result<Map<String, dynamic>, AppError> _handleResponse(Response response) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      if (body['success'] == true) {
        return Result.success(body);
      }
      // API returned {success: false, error: {code, message}}
      final error = body['error'];
      if (error is Map<String, dynamic>) {
        return Result.failure(GeneralDatabaseError(
          message: error['message'] ?? 'Unknown API error',
          code: error['code']?.toString(),
        ));
      }
    }
    return Result.success(body is Map<String, dynamic> ? body : {});
  }

  // --------------- Error mapping ---------------

  AppError _mapDioError(DioException e, StackTrace st) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutError(originalError: e, stackTrace: st);

      case DioExceptionType.connectionError:
        return NoConnectionError(originalError: e, stackTrace: st);

      case DioExceptionType.cancel:
        return CancelledError(originalError: e, stackTrace: st);

      case DioExceptionType.badResponse:
        return _mapStatusCode(e, st);

      default:
        return NetworkError(originalError: e, stackTrace: st);
    }
  }

  AppError _mapStatusCode(DioException e, StackTrace st) {
    final statusCode = e.response?.statusCode ?? 0;
    final body = e.response?.data;
    String message = 'Server error';

    if (body is Map<String, dynamic>) {
      final error = body['error'];
      if (error is Map<String, dynamic>) {
        message = error['message'] ?? message;
      } else if (body['detail'] is String) {
        message = body['detail'];
      }
    }

    switch (statusCode) {
      case 401:
        clearJwtCache();
        return SessionExpiredError(originalError: e, stackTrace: st);
      case 403:
        return PermissionDeniedError(
            message: message, originalError: e, stackTrace: st);
      case 404:
        return DocumentNotFoundError(
            message: message, originalError: e, stackTrace: st);
      case 409:
        return DocumentAlreadyExistsError(
            message: message, originalError: e, stackTrace: st);
      case 422:
        return ValidationError(
            message: message, originalError: e, stackTrace: st);
      case 429:
        return RateLimitError(originalError: e, stackTrace: st);
      default:
        if (statusCode >= 500) {
          return ServerError(
              statusCode: statusCode, originalError: e, stackTrace: st);
        }
        return GeneralDatabaseError(
            message: message, code: statusCode.toString(),
            originalError: e, stackTrace: st);
    }
  }
}
