import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
import 'package:car_wash_technician/app/helpers/secure_store.dart';
import 'package:car_wash_technician/app/helpers/shared_preferences.dart';
import 'package:car_wash_technician/app/repositories/auth/auth_repository.dart';
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
      errorToast("employee_id_is_required".tr);
      return;
    }

    if (password.isEmpty) {
      errorToast("password_is_required".tr);
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

        await SharedPrefsHelper.clearAll();

        await SharedPrefsHelper.setString("employeeId", employee["id"] ?? "");
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

        Get.offAllNamed(Routes.dashboard);
      }
    } on DioException catch (e) {
      errorToast(e.response?.data["message"] ?? "invalid_credentials".tr);
    }
  }
}
