import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import '../../services/api_service.dart';
import '../../services/endpoints.dart';
import '../../helpers/secure_store.dart';
import '../../helpers/shared_preferences.dart';

class BookingImageRepository {
  /// Upload images for a booking.
  /// Returns true on success, throws Exception on failure.
  /// CRITICAL: Use ApiService.dio (NOT a new Dio instance)
  /// CRITICAL: Send FormData directly (do NOT jsonEncode)
  /// CRITICAL: Let Dio handle Content-Type with multipart boundary
  Future<bool> uploadImages({
    required String bookingId,
    required String employeeId,
    required String imageType, // BEFORE | AFTER
    required List<File> images,
  }) async {
    if (images.isEmpty) {
      return true; // Nothing to upload
    }

    final formData = dio.FormData();

    // Add form fields
    formData.fields.addAll([
      MapEntry('booking_id', bookingId),
      MapEntry('employee_id', employeeId),
      MapEntry('image_type', imageType),
    ]);

    // Add image files
    for (final file in images) {
      formData.files.add(
        MapEntry(
          'images',
          await dio.MultipartFile.fromFile(file.path),
        ),
      );
    }

    // Get auth token
    final token = await FlutterSecureStore()
        .getSingleValue(SharedPrefsHelper.accessToken);

    if (token == null || token.isEmpty) {
      throw Exception('Auth token missing - please login again');
    }

    const endpoint = EndPoints.apiPostUploadImages;

    try {
      // Upload using ApiService.dio directly for multipart
      // NOTE: Do NOT JSON-encode FormData. Dio handles multipart serialization.
      // NOTE: Do NOT override Content-Type header - Dio sets it with correct boundary.
      final response = await ApiService.dio.post(
        endpoint,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Validate HTTP status (200-299 is success)
      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! > 299) {
        throw Exception(
          'Server error (HTTP ${response.statusCode}): ${response.statusMessage}',
        );
      }

      log('✓ $imageType images uploaded for booking $bookingId (HTTP ${response.statusCode})');
      return true;
    } on dio.DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 'Unknown';
      final errorMsg =
          e.response?.data.toString() ?? e.message ?? 'Network error';
      log('✗ DioException (HTTP $statusCode): $errorMsg');
      throw Exception('HTTP $statusCode - $errorMsg');
    }
  }
}
