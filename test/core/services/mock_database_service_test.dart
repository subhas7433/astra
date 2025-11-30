import 'package:flutter_test/flutter_test.dart';
import 'package:astra/app/core/services/mock/mock_database_service.dart';
import 'package:astra/app/core/services/interfaces/i_database_service.dart';
import 'package:astra/app/core/result/app_error.dart';

void main() {
  late MockDatabaseService dbService;

  const testCollection = 'test_collection';

  setUp(() {
    dbService = MockDatabaseService();
  });

  tearDown(() {
    dbService.reset();
  });

  group('MockDatabaseService', () {
    group('createDocument', () {
      test('should create document successfully', () async {
        final result = await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Test', 'value': 42},
        );

        expect(result.isSuccess, isTrue);
        final doc = result.valueOrNull!;
        expect(doc['\$id'], isNotNull);
        expect(doc['name'], 'Test');
        expect(doc['value'], 42);
        expect(doc['\$createdAt'], isNotNull);
        expect(doc['\$updatedAt'], isNotNull);
      });

      test('should create document with custom ID', () async {
        final result = await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Test'},
          documentId: 'custom_id',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!['\$id'], 'custom_id');
      });

      test('should return error if document ID already exists', () async {
        await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'First'},
          documentId: 'duplicate_id',
        );

        final result = await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Second'},
          documentId: 'duplicate_id',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DocumentAlreadyExistsError>());
      });

      test('should return forced error when forceError is true', () async {
        dbService.forceError = true;
        dbService.forcedError = const ValidationError(message: 'Test error');

        final result = await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Test'},
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
      });
    });

    group('getDocument', () {
      test('should get existing document', () async {
        final createResult = await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Test'},
          documentId: 'get_test_id',
        );
        final createdId = createResult.valueOrNull!['\$id'];

        final result = await dbService.getDocument(
          collectionId: testCollection,
          documentId: createdId,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!['name'], 'Test');
      });

      test('should return error for non-existent document', () async {
        final result = await dbService.getDocument(
          collectionId: testCollection,
          documentId: 'non_existent',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DocumentNotFoundError>());
      });

      test('should return error for non-existent collection', () async {
        final result = await dbService.getDocument(
          collectionId: 'non_existent_collection',
          documentId: 'some_id',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DocumentNotFoundError>());
      });
    });

    group('updateDocument', () {
      test('should update existing document', () async {
        await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Original', 'count': 1},
          documentId: 'update_test_id',
        );

        final result = await dbService.updateDocument(
          collectionId: testCollection,
          documentId: 'update_test_id',
          data: {'name': 'Updated', 'count': 2},
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!['name'], 'Updated');
        expect(result.valueOrNull!['count'], 2);
      });

      test('should preserve fields not in update data', () async {
        await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Original', 'preserved': 'value'},
          documentId: 'preserve_test_id',
        );

        final result = await dbService.updateDocument(
          collectionId: testCollection,
          documentId: 'preserve_test_id',
          data: {'name': 'Updated'},
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!['name'], 'Updated');
        expect(result.valueOrNull!['preserved'], 'value');
      });

      test('should return error for non-existent document', () async {
        final result = await dbService.updateDocument(
          collectionId: testCollection,
          documentId: 'non_existent',
          data: {'name': 'Updated'},
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DocumentNotFoundError>());
      });
    });

    group('deleteDocument', () {
      test('should delete existing document', () async {
        await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'ToDelete'},
          documentId: 'delete_test_id',
        );

        final deleteResult = await dbService.deleteDocument(
          collectionId: testCollection,
          documentId: 'delete_test_id',
        );

        expect(deleteResult.isSuccess, isTrue);

        // Verify it's deleted
        final getResult = await dbService.getDocument(
          collectionId: testCollection,
          documentId: 'delete_test_id',
        );
        expect(getResult.isFailure, isTrue);
      });

      test('should return error for non-existent document', () async {
        final result = await dbService.deleteDocument(
          collectionId: testCollection,
          documentId: 'non_existent',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DocumentNotFoundError>());
      });
    });

    group('listDocuments', () {
      test('should list all documents in collection', () async {
        // Create multiple documents
        for (var i = 0; i < 5; i++) {
          await dbService.createDocument(
            collectionId: testCollection,
            data: {'index': i},
          );
        }

        final result = await dbService.listDocuments(
          collectionId: testCollection,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.documents.length, 5);
        expect(result.valueOrNull!.total, 5);
      });

      test('should return empty list for empty collection', () async {
        final result = await dbService.listDocuments(
          collectionId: 'empty_collection',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.documents, isEmpty);
        expect(result.valueOrNull!.total, 0);
      });

      test('should respect limit option', () async {
        // Create multiple documents
        for (var i = 0; i < 10; i++) {
          await dbService.createDocument(
            collectionId: testCollection,
            data: {'index': i},
          );
        }

        final result = await dbService.listDocuments(
          collectionId: testCollection,
          options: const QueryOptions(limit: 5),
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.documents.length, 5);
        expect(result.valueOrNull!.total, 10);
        expect(result.valueOrNull!.hasMore, isTrue);
      });

      test('should respect offset option', () async {
        // Create multiple documents
        for (var i = 0; i < 5; i++) {
          await dbService.createDocument(
            collectionId: testCollection,
            data: {'index': i},
          );
        }

        final result = await dbService.listDocuments(
          collectionId: testCollection,
          options: const QueryOptions(offset: 2),
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.documents.length, 3);
      });
    });

    group('batchCreate', () {
      test('should create multiple documents', () async {
        final documents = [
          {'name': 'Doc1'},
          {'name': 'Doc2'},
          {'name': 'Doc3'},
        ];

        final result = await dbService.batchCreate(
          collectionId: testCollection,
          documents: documents,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.length, 3);

        // Verify all were created
        final listResult = await dbService.listDocuments(
          collectionId: testCollection,
        );
        expect(listResult.valueOrNull!.total, 3);
      });
    });

    group('documentExists', () {
      test('should return true for existing document', () async {
        await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Test'},
          documentId: 'exists_test_id',
        );

        final result = await dbService.documentExists(
          collectionId: testCollection,
          documentId: 'exists_test_id',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isTrue);
      });

      test('should return false for non-existent document', () async {
        final result = await dbService.documentExists(
          collectionId: testCollection,
          documentId: 'non_existent',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isFalse);
      });
    });

    group('seedCollection', () {
      test('should seed collection with test data', () async {
        dbService.seedCollection(testCollection, [
          {'\$id': 'seed1', 'name': 'Seeded 1'},
          {'\$id': 'seed2', 'name': 'Seeded 2'},
        ]);

        final result = await dbService.listDocuments(
          collectionId: testCollection,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.total, 2);
      });
    });

    group('getCollectionData', () {
      test('should return all documents in collection', () async {
        await dbService.createDocument(
          collectionId: testCollection,
          data: {'name': 'Test'},
        );

        final data = dbService.getCollectionData(testCollection);

        expect(data.length, 1);
        expect(data.first['name'], 'Test');
      });
    });
  });
}
