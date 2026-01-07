import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/helpers/secure_store.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
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
        final employee = response.data["employee"];
        final token = response.data["token"];

        // SAVE EMPLOYEE DETAILS
        await SharedPrefsHelper.setString(
          "employeeId",
          employee["id"] ?? "",
        );

        await SharedPrefsHelper.setString(
          "employeeName",
          "${employee["first_name"] ?? ""} ${employee["last_name"] ?? ""}",
        );

        await SharedPrefsHelper.setString(
          "employeeDesignation",
          employee["designation"] ?? "",
        );

        await FlutterSecureStore().storeSingleValue(
          SharedPrefsHelper.accessToken,
          token,
        );

        // OPTIONAL: DEBUG CHECK
        print("EMP ID = ${employee["id"]}");
        print("EMP NAME = ${employee["first_name"]} ${employee["last_name"]}");
        print("TOKEN = $token");

        // NAVIGATE
        Get.offAllNamed(Routes.dashboard);
      }
    } on DioException catch (e) {
      errorToast(e.response?.data["message"] ?? "Invalid credentials");
    }
  }
}
