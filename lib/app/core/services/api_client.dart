import 'package:appwrite/appwrite.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/appwrite_config.dart';
import '../result/app_error.dart';
import '../result/result.dart';
import '../utils/app_logger.dart';
import '../../global/widgets/upgrade_dialog.dart';
import '../../data/providers/appwrite_client_provider.dart';

class ApiClient {
  static const String _tag = 'ApiClient';

  final Dio _dio;
  final Account _account;

  String? _cachedJwt;
  DateTime? _jwtExpiry;
  String _appVersion = '';

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

    // Initialize app version asynchronously
    PackageInfo.fromPlatform().then((info) {
      client._appVersion = info.version;
    }).catchError((_) {
      // Fallback if package info unavailable
      client._appVersion = '';
    });

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final jwt = await client._getJwt();
        if (jwt != null) {
          options.headers['Authorization'] = 'Bearer $jwt';
          AppLogger.debug(
            '${options.method} ${options.path}',
            tag: _tag,
          );
          AppLogger.debug('FULL_JWT: $jwt', tag: _tag);
        } else {
          AppLogger.warning(
            '${options.method} ${options.path} [NO JWT - guest request]',
            tag: _tag,
          );
        }
        if (client._appVersion.isNotEmpty) {
          options.headers['X-App-Version'] = client._appVersion;
        }
        handler.next(options);
      },
      onError: (error, handler) {
        AppLogger.error(
          '${error.requestOptions.method} ${error.requestOptions.path} -> ${error.response?.statusCode}',
          tag: _tag,
          error: error,
        );
        // Intercept 426 globally and show upgrade dialog
        if (error.response?.statusCode == 426) {
          UpgradeDialog.show();
        }
        handler.next(error);
      },
    ));

    return client;
  }

  Future<String?> _getJwt() async {
    if (_cachedJwt != null &&
        _jwtExpiry != null &&
        DateTime.now().isBefore(_jwtExpiry!)) {
      AppLogger.debug('Using cached JWT', tag: _tag);
      return _cachedJwt;
    }

    AppLogger.debug('Creating new JWT...', tag: _tag);
    try {
      final jwt = await _account.createJWT();
      _cachedJwt = jwt.jwt;
      // Appwrite JWTs last 15 min; refresh at 13 min
      _jwtExpiry = DateTime.now().add(const Duration(minutes: 13));
      AppLogger.debug('JWT created successfully', tag: _tag);
      return _cachedJwt;
    } catch (e) {
      AppLogger.error('JWT creation failed: $e', tag: _tag);
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
      case 426:
        String? minVersion;
        String? storeUrl;
        if (body is Map<String, dynamic>) {
          final details = (body['error'] as Map<String, dynamic>?)?['details'];
          if (details is Map<String, dynamic>) {
            minVersion = details['min_version']?.toString();
            storeUrl = details['store_url']?.toString();
          }
        }
        return UpgradeRequiredError(
            minVersion: minVersion,
            storeUrl: storeUrl,
            originalError: e,
            stackTrace: st);
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
