import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/result/result.dart';
import '../core/result/app_error.dart';
import '../core/utils/app_logger.dart';

/// View state enum for UI state management.
enum ViewState {
  /// Initial state before any operation
  initial,

  /// Loading state during async operations
  loading,

  /// Success state after data is loaded
  loaded,

  /// Error state when operation fails
  error,
}

/// Base controller providing common functionality for all controllers.
///
/// Features:
/// - ViewState management (initial, loading, loaded, error)
/// - Error message handling
/// - Result processing helpers
/// - Lifecycle logging
///
/// Usage:
/// ```dart
/// class HomeController extends BaseController {
///   @override
///   String get tag => 'HomeController';
///
///   final items = <ItemModel>[].obs;
///
///   Future<void> loadItems() async {
///     await executeWithState(
///       operation: () => repository.getItems(),
///       onSuccess: (data) => items.value = data,
///     );
///   }
/// }
/// ```
///
/// See also: [executeWithState], [handleResult]
abstract class BaseController extends GetxController {
  /// Tag for logging - override in subclass for specific tag
  String get tag => runtimeType.toString();

  // ============ State Management ============

  /// Current view state
  final Rx<ViewState> viewState = ViewState.initial.obs;

  /// Error message (empty when no error)
  final RxString errorMessage = ''.obs;

  /// Whether the controller is in loading state
  bool get isLoading => viewState.value == ViewState.loading;

  /// Whether there's an active error
  bool get hasError => viewState.value == ViewState.error;

  /// Whether data is loaded successfully
  bool get isLoaded => viewState.value == ViewState.loaded;

  /// Whether in initial state
  bool get isInitial => viewState.value == ViewState.initial;

  // ============ State Setters ============

  /// Set loading state and clear error
  @protected
  void setLoading() {
    viewState.value = ViewState.loading;
    errorMessage.value = '';
  }

  /// Set loaded state
  @protected
  void setLoaded() {
    viewState.value = ViewState.loaded;
  }

  /// Set error state with message
  @protected
  void setError(String message) {
    viewState.value = ViewState.error;
    errorMessage.value = message;
    AppLogger.warning('Error state: $message', tag: tag);
  }

  /// Reset to initial state
  @protected
  void resetState() {
    viewState.value = ViewState.initial;
    errorMessage.value = '';
  }

  // ============ Result Handling ============

  /// Execute an async operation with state management.
  ///
  /// Automatically:
  /// - Sets loading state
  /// - Handles success/failure
  /// - Sets appropriate end state
  /// - Logs errors
  ///
  /// Returns the value on success, null on failure.
  ///
  /// Example:
  /// ```dart
  /// final user = await executeWithState(
  ///   operation: () => authService.login(email, password),
  ///   onSuccess: (userId) => navigateToHome(),
  ///   onError: (error) => showSnackbar(error.message),
  /// );
  /// ```
  @protected
  Future<T?> executeWithState<T>({
    required Future<Result<T, AppError>> Function() operation,
    void Function(T value)? onSuccess,
    void Function(AppError error)? onError,
  }) async {
    setLoading();

    try {
      final result = await operation();

      return result.fold(
        onSuccess: (value) {
          setLoaded();
          onSuccess?.call(value);
          return value;
        },
        onFailure: (error) {
          setError(error.message);
          AppLogger.error(
            'Operation failed: ${error.message}',
            tag: tag,
            error: error.originalError,
            stackTrace: error.stackTrace,
          );
          onError?.call(error);
          return null;
        },
      );
    } catch (e, stack) {
      setError(e.toString());
      AppLogger.error(
        'Unexpected error: $e',
        tag: tag,
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Handle a Result without state management.
  ///
  /// Use this when you want to handle a result manually
  /// without changing the view state.
  @protected
  T? handleResult<T>(
    Result<T, AppError> result, {
    void Function(T value)? onSuccess,
    void Function(AppError error)? onError,
  }) {
    return result.fold(
      onSuccess: (value) {
        onSuccess?.call(value);
        return value;
      },
      onFailure: (error) {
        AppLogger.warning('Result failure: ${error.message}', tag: tag);
        onError?.call(error);
        return null;
      },
    );
  }

  // ============ Lifecycle ============

  @override
  void onInit() {
    super.onInit();
    AppLogger.debug('$tag initialized', tag: tag);
  }

  @override
  void onReady() {
    super.onReady();
    AppLogger.debug('$tag ready', tag: tag);
  }

  @override
  void onClose() {
    AppLogger.debug('$tag closed', tag: tag);
    super.onClose();
  }
}
