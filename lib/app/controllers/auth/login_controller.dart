import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/repositories/auth/auth_repository.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final employeeIdController = TextEditingController();
  final passwordController = TextEditingController();

  var showPassword = false.obs;

  Future<void> login() async {
    final employeeId = employeeIdController.text.trim();
    final password = passwordController.text.trim();

    if (employeeId.isEmpty) {
      errorToast("Employee ID is required");
      return;
    }

    if (password.isEmpty) {
      errorToast("Password is required");
      return;
    }

    try {
      final response = await _repo.postLogin({
        "user_id": employeeId,
        "password": password,
      });

      if (response.data["success"] == true) {
        Get.offAllNamed(Routes.dashboard);
      }
    } on DioException catch (e) {
      errorToast(e.response?.data["message"] ?? "Invalid credentials");
    }
  }
}
