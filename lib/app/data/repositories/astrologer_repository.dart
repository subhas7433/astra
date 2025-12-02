import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import '../models/astrologer_model.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../models/enums/astrologer_category.dart';

class AstrologerRepository {
  final Databases _databases = Get.find<Databases>();

  // Collection ID (Replace with actual ID)
  static const String collectionId = 'astrologers';
  static const String databaseId = 'astra_db';

  Future<Result<List<AstrologerModel>, AppError>> getAstrologers({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final documentList = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.limit(limit),
          Query.offset(offset),
        ],
      );

      final astrologers = documentList.documents.map((doc) {
        return AstrologerModel.fromJson(doc.data);
      }).toList();
      
      return Result.success(astrologers);
    } on AppwriteException catch (e, stack) {
      return Result.failure(UnknownError(
        message: 'Failed to fetch astrologers: ${e.message}',
        originalError: e,
        stackTrace: stack,
      ));
    } catch (e, stack) {
      return Result.failure(UnknownError(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  Future<Result<AstrologerModel, AppError>> getAstrologerById(String id) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );
      
      return Result.success(AstrologerModel.fromJson(doc.data));
    } on AppwriteException catch (e, stack) {
      return Result.failure(UnknownError(
        message: 'Failed to fetch astrologer: ${e.message}',
        originalError: e,
        stackTrace: stack,
      ));
    } catch (e, stack) {
      return Result.failure(UnknownError(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }
}
