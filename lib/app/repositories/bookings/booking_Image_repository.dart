// lib/app/repositories/bookings/booking_image_repository.dart

import 'dart:io';
import 'package:dio/dio.dart' as dio;

import 'package:my_new_app/app/config/environment.dart';
import '../../services/endpoints.dart';
import '../../helpers/secure_store.dart';
import '../../helpers/shared_preferences.dart';

class BookingImageRepository {
  Future<bool> uploadImages({
    required String bookingId,
    required String employeeId,
    required String imageType,
    required List<File> images,
  }) async {
    // ✅ Create a fresh Dio instance (safe for multipart)
    final dio.Dio dioClient = dio.Dio();

    final token = await FlutterSecureStore()
        .getSingleValue(SharedPrefsHelper.accessToken);

    // ✅ Build FormData correctly
    final dio.FormData formData = dio.FormData.fromMap({
      'booking_id': bookingId,
      'employee_id': employeeId,
      'image_type': imageType,
      'images': images
          .map(
            (f) => dio.MultipartFile.fromFileSync(f.path),
          )
          .toList(),
    });

    // ✅ Make request
    final response = await dioClient.post(
      Environment.baseUrl + EndPoints.apiPostUploadImages,
      data: formData,
      options: dio.Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.statusCode == 200;
  }
}
