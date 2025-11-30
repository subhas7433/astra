import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized logging utility with environment-aware output.
///
/// Usage:
/// ```dart
/// AppLogger.debug('Debug message');
/// AppLogger.info('Info message', tag: 'AuthService');
/// AppLogger.error('Error occurred', error: e, stackTrace: stackTrace);
/// ```
class AppLogger {
  static bool get _isDebug {
    try {
      return dotenv.env['DEBUG'] == 'true';
    } catch (_) {
      // dotenv not initialized (e.g., in tests)
      return true;
    }
  }

  /// Log debug messages (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (_isDebug) {
      _log('DEBUG', message, tag: tag);
    }
  }

  /// Log info messages
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  /// Log warning messages
  static void warning(String message, {String? tag}) {
    _log('WARNING', message, tag: tag);
  }

  /// Log error messages with optional error object and stack trace
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, tag: tag);
    if (error != null) {
      debugPrint('Error: $error');
    }
    if (stackTrace != null && _isDebug) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  static void _log(String level, String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    debugPrint('$timestamp [$level]$tagStr $message');
  }
}
