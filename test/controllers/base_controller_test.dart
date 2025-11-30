import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:astra/app/controllers/base_controller.dart';
import 'package:astra/app/core/result/result.dart';
import 'package:astra/app/core/result/app_error.dart';

/// Concrete implementation of BaseController for testing
class TestController extends BaseController {
  @override
  String get tag => 'TestController';

  /// Expose protected methods for testing
  void testSetLoading() => setLoading();
  void testSetLoaded() => setLoaded();
  void testSetError(String message) => setError(message);
  void testResetState() => resetState();

  /// Test helper for executeWithState
  Future<T?> testExecuteWithState<T>({
    required Future<Result<T, AppError>> Function() operation,
    void Function(T value)? onSuccess,
    void Function(AppError error)? onError,
  }) {
    return executeWithState(
      operation: operation,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// Test helper for handleResult
  T? testHandleResult<T>(
    Result<T, AppError> result, {
    void Function(T value)? onSuccess,
    void Function(AppError error)? onError,
  }) {
    return handleResult(result, onSuccess: onSuccess, onError: onError);
  }
}

void main() {
  late TestController controller;

  setUpAll(() {
    Get.testMode = true;
  });

  setUp(() {
    controller = Get.put(TestController());
  });

  tearDown(() async {
    if (Get.isRegistered<TestController>()) {
      Get.delete<TestController>(force: true);
    }
    Get.reset();
  });

  group('BaseController', () {
    group('initial state', () {
      test('viewState should be initial on creation', () {
        expect(controller.viewState.value, ViewState.initial);
      });

      test('errorMessage should be empty on creation', () {
        expect(controller.errorMessage.value, '');
      });

      test('isInitial should be true on creation', () {
        expect(controller.isInitial, isTrue);
      });

      test('isLoading should be false on creation', () {
        expect(controller.isLoading, isFalse);
      });

      test('hasError should be false on creation', () {
        expect(controller.hasError, isFalse);
      });

      test('isLoaded should be false on creation', () {
        expect(controller.isLoaded, isFalse);
      });
    });

    group('setLoading', () {
      test('should set viewState to loading', () {
        controller.testSetLoading();
        expect(controller.viewState.value, ViewState.loading);
        expect(controller.isLoading, isTrue);
      });

      test('should clear errorMessage', () {
        controller.testSetError('Previous error');
        controller.testSetLoading();
        expect(controller.errorMessage.value, '');
      });
    });

    group('setLoaded', () {
      test('should set viewState to loaded', () {
        controller.testSetLoaded();
        expect(controller.viewState.value, ViewState.loaded);
        expect(controller.isLoaded, isTrue);
      });
    });

    group('setError', () {
      test('should set viewState to error', () {
        controller.testSetError('Test error');
        expect(controller.viewState.value, ViewState.error);
        expect(controller.hasError, isTrue);
      });

      test('should set errorMessage', () {
        controller.testSetError('Test error message');
        expect(controller.errorMessage.value, 'Test error message');
      });
    });

    group('resetState', () {
      test('should reset to initial state', () {
        controller.testSetError('Some error');
        controller.testResetState();
        expect(controller.viewState.value, ViewState.initial);
        expect(controller.isInitial, isTrue);
      });

      test('should clear errorMessage', () {
        controller.testSetError('Some error');
        controller.testResetState();
        expect(controller.errorMessage.value, '');
      });
    });

    group('executeWithState', () {
      test('should return value on success', () async {
        final result = await controller.testExecuteWithState<String>(
          operation: () async => const Success('test value'),
        );

        expect(result, 'test value');
        expect(controller.isLoaded, isTrue);
      });

      test('should call onSuccess callback on success', () async {
        String? capturedValue;

        await controller.testExecuteWithState<String>(
          operation: () async => const Success('test value'),
          onSuccess: (value) => capturedValue = value,
        );

        expect(capturedValue, 'test value');
      });

      test('should return null on failure', () async {
        final result = await controller.testExecuteWithState<String>(
          operation: () async =>
              const Failure(ValidationError(message: 'Test error')),
        );

        expect(result, isNull);
        expect(controller.hasError, isTrue);
      });

      test('should set error message on failure', () async {
        await controller.testExecuteWithState<String>(
          operation: () async =>
              const Failure(ValidationError(message: 'Validation failed')),
        );

        expect(controller.errorMessage.value, 'Validation failed');
      });

      test('should call onError callback on failure', () async {
        AppError? capturedError;

        await controller.testExecuteWithState<String>(
          operation: () async =>
              const Failure(NetworkError(message: 'Network failed')),
          onError: (error) => capturedError = error,
        );

        expect(capturedError, isA<NetworkError>());
      });

      test('should set loading state during operation', () async {
        ViewState? stateWhileLoading;

        await controller.testExecuteWithState<String>(
          operation: () async {
            stateWhileLoading = controller.viewState.value;
            return const Success('done');
          },
        );

        expect(stateWhileLoading, ViewState.loading);
      });

      test('should handle thrown exceptions', () async {
        final result = await controller.testExecuteWithState<String>(
          operation: () async => throw Exception('Unexpected error'),
        );

        expect(result, isNull);
        expect(controller.hasError, isTrue);
        expect(controller.errorMessage.value, contains('Exception'));
      });
    });

    group('handleResult', () {
      test('should return value on success', () {
        final result = controller.testHandleResult<int>(const Success(42));

        expect(result, 42);
      });

      test('should call onSuccess callback', () {
        int? capturedValue;

        controller.testHandleResult<int>(
          const Success(42),
          onSuccess: (value) => capturedValue = value,
        );

        expect(capturedValue, 42);
      });

      test('should return null on failure', () {
        final result = controller.testHandleResult<int>(
          const Failure(ValidationError(message: 'Error')),
        );

        expect(result, isNull);
      });

      test('should call onError callback on failure', () {
        AppError? capturedError;

        controller.testHandleResult<int>(
          const Failure(NetworkError(message: 'Failed')),
          onError: (error) => capturedError = error,
        );

        expect(capturedError, isA<NetworkError>());
      });

      test('should not change viewState', () {
        final initialState = controller.viewState.value;

        controller.testHandleResult<int>(
          const Failure(ValidationError(message: 'Error')),
        );

        expect(controller.viewState.value, initialState);
      });
    });

    group('tag', () {
      test('should return the controller tag', () {
        expect(controller.tag, 'TestController');
      });
    });
  });

  group('ViewState', () {
    test('should have all expected values', () {
      expect(ViewState.values, contains(ViewState.initial));
      expect(ViewState.values, contains(ViewState.loading));
      expect(ViewState.values, contains(ViewState.loaded));
      expect(ViewState.values, contains(ViewState.error));
      expect(ViewState.values.length, 4);
    });
  });
}
