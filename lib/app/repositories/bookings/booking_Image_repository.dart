// lib/app/repositories/bookings/booking_image_repository.dart

import 'dart:io';
import 'package:dio/dio.dart' as dio;

import 'package:car_wash_technician/app/config/environment.dart';
import '../../services/endpoints.dart';
import '../../helpers/secure_store.dart';
import '../../helpers/shared_preferences.dart';

class BookingImageRepository {
  Future<bool> uploadMedia({
    required String bookingId,
    required String employeeId,
    required String imageType,
    required String videoType,
    required List<File> images,
    required List<File> videos,
  }) async {
    final dio.Dio dioClient = dio.Dio();

    final token = await FlutterSecureStore()
        .getSingleValue(SharedPrefsHelper.accessToken);
    final dio.FormData formData = dio.FormData.fromMap({
      'booking_id': bookingId,
      'employee_id': employeeId,
      'image_type': imageType,
      'video_type': videoType, // ✅ ADD THIS
      'images':
          images.map((f) => dio.MultipartFile.fromFileSync(f.path)).toList(),
      'videos':
          videos.map((f) => dio.MultipartFile.fromFileSync(f.path)).toList(),
    });

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
