import 'dart:io';
import 'package:dio/dio.dart';

import 'dart:io';
import 'package:dio/dio.dart';

class BookingImageRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<bool> uploadImages({
    required String bookingId,
    required String employeeId,
    required String imageType,
    required List<File> images,
  }) async {
    try {
      final formData = FormData.fromMap({
        'booking_id': bookingId,
        'employee_id': employeeId,
        'image_type': imageType,
        'images': images
            .map(
              (file) => MultipartFile.fromFileSync(file.path),
            )
            .toList(),
      });

      final response = await _dio.post(
        // ✅ Emulator-safe URL
        'http://10.0.2.2:3000/api/employee/bookings/upload-images',
        data: formData,
      );

      print('UPLOAD STATUS → ${response.statusCode}');
      print('UPLOAD BODY → ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('UPLOAD ERROR → $e');
      return false;
    }
  }
}
