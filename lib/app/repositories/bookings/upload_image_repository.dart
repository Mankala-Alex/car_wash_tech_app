// import 'dart:developer';
// import 'dart:io';

// import 'package:dio/dio.dart' as dio;
// import '../../services/api_service.dart';
// import '../../services/endpoints.dart';
// import '../../helpers/secure_store.dart';
// import '../../helpers/shared_preferences.dart';

// class BookingImageRepository {
//   /// Upload BEFORE / AFTER wash images
//   ///
//   /// imageType → "BEFORE" | "AFTER"
//   /// Uses ApiService.dio (IMPORTANT)
//   /// Sends JWT token in Authorization header
//   ///
//   /// Returns true on success
//   /// Throws Exception on failure
//   Future<bool> uploadImages({
//     required String bookingId,
//     required String employeeId,
//     required String imageType,
//     required List<File> images,
//   }) async {
//     // Nothing to upload
//     if (images.isEmpty) return true;

//     /// 1️⃣ Build multipart form-data
//     final formData = dio.FormData();

//     // Fields
//     formData.fields.addAll([
//       MapEntry('booking_id', bookingId),
//       MapEntry('employee_id', employeeId),
//       MapEntry('image_type', imageType), // BEFORE / AFTER
//     ]);

//     // Files
//     for (final file in images) {
//       formData.files.add(
//         MapEntry(
//           'images',
//           await dio.MultipartFile.fromFile(file.path),
//         ),
//       );
//     }

//     /// 2️⃣ Get token from secure storage
//     final token = await FlutterSecureStore()
//         .getSingleValue(SharedPrefsHelper.accessToken);

//     if (token == null || token.isEmpty) {
//       throw Exception("Auth token missing. Please login again.");
//     }

//     /// 3️⃣ Call API (DO NOT override Content-Type)
//     try {
//       final response = await ApiService.dio.post(
//         EndPoints.apiPostUploadImages,
//         data: formData,
//         options: dio.Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       // Validate success
//       if (response.statusCode == null ||
//           response.statusCode! < 200 ||
//           response.statusCode! > 299) {
//         throw Exception(
//           "Upload failed (HTTP ${response.statusCode})",
//         );
//       }

//       log("✅ $imageType images uploaded for booking $bookingId");
//       return true;
//     } on dio.DioException catch (e) {
//       final status = e.response?.statusCode ?? "Unknown";
//       final msg = e.response?.data?.toString() ?? e.message;
//       log("❌ Upload error [$status] → $msg");
//       throw Exception("Upload failed: $msg");
//     }
//   }
// }
