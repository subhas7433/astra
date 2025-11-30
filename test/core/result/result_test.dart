import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/core/result/result.dart';
import 'package:astra/app/core/result/app_error.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create success with value', () {
        const result = Result<int, String>.success(42);

        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.valueOrNull, 42);
        expect(result.errorOrNull, isNull);
      });

      test('should support null value for void operations', () {
        const result = Result<void, String>.success(null);

        expect(result.isSuccess, isTrue);
        // void type has no value to check
      });
    });

    group('Failure', () {
      test('should create failure with error', () {
        const result = Result<int, String>.failure('Error occurred');

        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.valueOrNull, isNull);
        expect(result.errorOrNull, 'Error occurred');
      });
    });

    group('map', () {
      test('should transform success value', () {
        const result = Result<int, String>.success(42);
        final mapped = result.map((v) => v.toString());

        expect(mapped.isSuccess, isTrue);
        expect(mapped.valueOrNull, '42');
      });

      test('should pass through failure without transform', () {
        const result = Result<int, String>.failure('Error');
        final mapped = result.map((v) => v.toString());

        expect(mapped.isFailure, isTrue);
        expect(mapped.errorOrNull, 'Error');
      });
    });

    group('fold', () {
      test('should call onSuccess for success result', () {
        const result = Result<int, String>.success(42);

        final folded = result.fold(
          onSuccess: (v) => 'Value: $v',
          onFailure: (e) => 'Error: $e',
        );

        expect(folded, 'Value: 42');
      });

      test('should call onFailure for failure result', () {
        const result = Result<int, String>.failure('Error');

        final folded = result.fold(
          onSuccess: (v) => 'Value: $v',
          onFailure: (e) => 'Error: $e',
        );

        expect(folded, 'Error: Error');
      });
    });

    group('getOrElse', () {
      test('should return value for success', () {
        const result = Result<int, String>.success(42);

        expect(result.getOrElse(0), 42);
      });

      test('should return default for failure', () {
        const result = Result<int, String>.failure('Error');

        expect(result.getOrElse(0), 0);
      });
    });
  });

  group('AppError', () {
    group('AuthError', () {
      test('InvalidCredentialsError should have correct message', () {
        const error = InvalidCredentialsError(message: 'Wrong password');
        expect(error.message, 'Wrong password');
        expect(error, isA<AuthError>());
      });

      test('UserNotFoundError should have default message', () {
        const error = UserNotFoundError();
        expect(error.message, 'User not found');
        expect(error, isA<AuthError>());
      });

      test('EmailAlreadyExistsError should have default message', () {
        const error = EmailAlreadyExistsError();
        expect(error.message, 'An account with this email already exists');
        expect(error, isA<AuthError>());
      });
    });

    group('DatabaseError', () {
      test('DocumentNotFoundError should have default message', () {
        const error = DocumentNotFoundError();
        expect(error.message, 'Document not found');
        expect(error, isA<DatabaseError>());
      });

      test('DocumentAlreadyExistsError should have default message', () {
        const error = DocumentAlreadyExistsError();
        expect(error.message, 'Document already exists');
        expect(error, isA<DatabaseError>());
      });
    });

    group('StorageError', () {
      test('FileNotFoundError should have default message', () {
        const error = FileNotFoundError();
        expect(error.message, 'File not found');
        expect(error, isA<StorageError>());
      });

      test('FileTooLargeError should have default message', () {
        const error = FileTooLargeError();
        expect(error.message, 'File exceeds maximum allowed size');
        expect(error, isA<StorageError>());
      });
    });

    group('Error properties', () {
      test('should store original error and stack trace', () {
        final originalError = Exception('Original');
        final stackTrace = StackTrace.current;

        final error = NetworkError(
          message: 'Network failed',
          originalError: originalError,
          stackTrace: stackTrace,
        );

        expect(error.originalError, originalError);
        expect(error.stackTrace, stackTrace);
      });

      test('should store error code', () {
        const error = UnknownError(
          message: 'Unknown',
          code: '500',
        );

        expect(error.code, '500');
      });
    });
  });
}
