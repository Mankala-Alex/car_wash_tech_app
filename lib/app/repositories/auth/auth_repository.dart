import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../../services/endpoints.dart';

class AuthRepository {
  //login
  Future<Response> postLogin(requestBody) async {
    return await ApiService.post(EndPoints.apipostlogin, requestBody,
        requireAuthToken: false);
  }

  Future<void> logoutTechnician() async {
    return ApiService.post(
      EndPoints.apiTechnicianLogout,
      {}, // empty body
      requireAuthToken: true,
    );
  }
}
