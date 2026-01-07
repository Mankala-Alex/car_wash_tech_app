import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../../services/endpoints.dart';

class ProfileRepository {
  Future<Response> changeEmployeePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await ApiService.post(
      EndPoints.apiPostChangePassword,
      {
        "current_password": currentPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      },
      requireAuthToken: true, // ✅ MUST BE TRUE
    );
  }
}
