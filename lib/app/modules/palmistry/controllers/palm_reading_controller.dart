import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import '../../../controllers/user_controller.dart';
import '../../../core/result/result.dart';
import '../../../core/result/app_error.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/interfaces/i_auth_service.dart';
import '../../../data/models/enums/gender.dart';
import '../../../data/models/palm_status_model.dart';
import '../../../data/repositories/palmistry_repository.dart';
import '../../../routes/app_routes.dart';

class PalmReadingController extends GetxController {
  final PalmistryRepository _palmistryRepository =
      Get.find<PalmistryRepository>();
  final ApiClient _api = Get.find<ApiClient>();
  final IAuthService _authService = Get.find<IAuthService>();

  // Image selection state
  final Rxn<Uint8List> leftPalmImage = Rxn<Uint8List>();
  final Rxn<Uint8List> rightPalmImage = Rxn<Uint8List>();
  final leftPalmFileName = ''.obs;
  final rightPalmFileName = ''.obs;

  // Upload & reading state
  final isUploading = false.obs;
  final isCreating = false.obs;
  final uploadProgress = ''.obs;

  // Status state
  final palmStatus = Rxn<PalmStatusModel>();
  final isLoadingStatus = true.obs;

  // Subject details (person being read)
  final subjectNameController = TextEditingController();
  final subjectBirthPlaceController = TextEditingController();
  final Rx<Gender> subjectGender = Gender.other.obs;
  final Rxn<DateTime> subjectDateOfBirth = Rxn<DateTime>();
  final Rxn<String> subjectBirthTime = Rxn<String>();
  final isSubjectExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    _prefillSubjectFromProfile();
    _loadPalmStatus();
  }

  Future<void> _loadPalmStatus() async {
    isLoadingStatus.value = true;

    final userId = _authService.currentUserId;
    if (userId == null) {
      Get.snackbar('Error', 'Please login to continue');
      isLoadingStatus.value = false;
      return;
    }

    final result = await _palmistryRepository.getPalmStatus(userId);
    result.fold(
      onSuccess: (status) {
        palmStatus.value = status;
      },
      onFailure: (error) {
        Get.snackbar('Error', error.message);
      },
    );

    isLoadingStatus.value = false;
  }

  void _prefillSubjectFromProfile() {
    try {
      final userController = Get.find<UserController>();
      final user = userController.user.value;
      if (user != null) {
        subjectNameController.text = user.fullName;
        subjectGender.value = user.gender;
        subjectDateOfBirth.value = user.dateOfBirth;
        subjectBirthTime.value = user.birthTime;
        if (user.birthPlace != null) {
          subjectBirthPlaceController.text = user.birthPlace!;
        }
      }
    } catch (_) {
      // UserController not available, leave defaults
    }
  }

  Future<void> pickSubjectDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: subjectDateOfBirth.value ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Select date of birth',
    );
    if (picked != null) {
      subjectDateOfBirth.value = picked;
    }
  }

  Future<void> pickSubjectBirthTime(BuildContext context) async {
    final initial = _parseTimeOfDay(subjectBirthTime.value);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? const TimeOfDay(hour: 12, minute: 0),
      helpText: 'Select birth time (optional)',
    );
    if (picked != null) {
      // Store in HH:mm:ss format for API
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      subjectBirthTime.value = '$hour:$minute:00';
    }
  }

  TimeOfDay? _parseTimeOfDay(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return null;
    }
  }

  String get subjectBirthTimeDisplay {
    final t = subjectBirthTime.value;
    if (t == null || t.isEmpty) return '';
    final tod = _parseTimeOfDay(t);
    if (tod == null) return '';
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${tod.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> pickImage({required bool isLeftPalm}) async {
    final ImagePicker picker = ImagePicker();

    // Show source selection (camera vs gallery)
    final ImageSource? source = await Get.dialog<ImageSource>(
      AlertDialog(
        title: Text('Select ${isLeftPalm ? "Left" : "Right"} Palm Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      // Validate size (max 10MB)
      const maxSize = 10 * 1024 * 1024;
      if (bytes.length > maxSize) {
        Get.snackbar(
          'Image Too Large',
          'Please select an image smaller than 10MB',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Store image
      if (isLeftPalm) {
        leftPalmImage.value = bytes;
        leftPalmFileName.value = image.name;
      } else {
        rightPalmImage.value = bytes;
        rightPalmFileName.value = image.name;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  void removeImage({required bool isLeftPalm}) {
    if (isLeftPalm) {
      leftPalmImage.value = null;
      leftPalmFileName.value = '';
    } else {
      rightPalmImage.value = null;
      rightPalmFileName.value = '';
    }
  }

  Future<void> createReading() async {
    if (!canCreateReading) {
      Get.snackbar('Error', 'Please select both palm images');
      return;
    }

    final userId = _authService.currentUserId;
    if (userId == null) {
      Get.snackbar('Error', 'Please login to continue');
      return;
    }

    try {
      // Step 1: Upload left palm image
      isUploading.value = true;
      uploadProgress.value = 'Uploading left palm...';

      final leftUrlResult = await _uploadPalmImage(
        leftPalmImage.value!,
        leftPalmFileName.value,
        'left',
      );

      if (leftUrlResult.isFailure) {
        Get.snackbar('Upload Failed', leftUrlResult.errorOrNull!.message);
        isUploading.value = false;
        return;
      }

      final leftUrl = leftUrlResult.valueOrNull!;

      // Step 2: Upload right palm image
      uploadProgress.value = 'Uploading right palm...';

      final rightUrlResult = await _uploadPalmImage(
        rightPalmImage.value!,
        rightPalmFileName.value,
        'right',
      );

      if (rightUrlResult.isFailure) {
        Get.snackbar('Upload Failed', rightUrlResult.errorOrNull!.message);
        isUploading.value = false;
        return;
      }

      final rightUrl = rightUrlResult.valueOrNull!;

      // Step 3: Create palm reading session
      isUploading.value = false;
      isCreating.value = true;
      uploadProgress.value = 'Generating your reading...';

      final createResult = await _palmistryRepository.createReading(
        leftPalmImageUrl: leftUrl,
        rightPalmImageUrl: rightUrl,
        tradition: 'vedic',
        readingLanguage: 'en',
        subjectName: subjectNameController.text.trim().isNotEmpty
            ? subjectNameController.text.trim()
            : null,
        subjectGender: subjectGender.value,
        subjectDateOfBirth: subjectDateOfBirth.value,
        subjectBirthTime: subjectBirthTime.value,
        subjectBirthPlace: subjectBirthPlaceController.text.trim().isNotEmpty
            ? subjectBirthPlaceController.text.trim()
            : null,
      );

      isCreating.value = false;
      uploadProgress.value = '';

      createResult.fold(
        onSuccess: (result) {
          // Clear images
          leftPalmImage.value = null;
          rightPalmImage.value = null;
          leftPalmFileName.value = '';
          rightPalmFileName.value = '';

          // Navigate to chat screen with session ID
          Get.toNamed(
            AppRoutes.palmReadingChatWithId(result.session.id),
          );
        },
        onFailure: (error) {
          Get.snackbar(
            'Creation Failed',
            error.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      isUploading.value = false;
      isCreating.value = false;
      uploadProgress.value = '';
      Get.snackbar('Error', 'Failed to create reading: $e');
    }
  }

  Future<Result<String, AppError>> _uploadPalmImage(
    Uint8List imageBytes,
    String fileName,
    String hand,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: fileName.isNotEmpty
              ? fileName
              : '${hand}_palm_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final result = await _api.postMultipart(
        '/api/v1/upload/palm-image',
        formData,
        queryParameters: {'hand': hand},
      );

      return result.fold(
        onSuccess: (body) {
          final data = body['data'] as Map<String, dynamic>?;
          if (data == null || data['url'] == null) {
            return const Result.failure(
              GeneralDatabaseError(message: 'Upload failed - no URL returned'),
            );
          }
          return Result.success(data['url'].toString());
        },
        onFailure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure(UnknownError(originalError: e));
    }
  }

  bool get canCreateReading =>
      leftPalmImage.value != null && rightPalmImage.value != null;

  bool get isProcessing => isUploading.value || isCreating.value;

  @override
  void onClose() {
    subjectNameController.dispose();
    subjectBirthPlaceController.dispose();
    super.onClose();
  }
}
