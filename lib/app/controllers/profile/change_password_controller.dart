import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
import 'package:car_wash_technician/app/models/profile/change_password_model.dart';
import 'package:car_wash_technician/app/repositories/profile/profile_repostory.dart';

class ChangePasswordController extends GetxController {
  final ProfileRepository repository = ProfileRepository();

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isLoading = false.obs;

  final showCurrent = false.obs;
  final showNew = false.obs;
  final showConfirm = false.obs;

  // ================= VALIDATION =================
  bool validate() {
    if (currentPasswordCtrl.text.trim().isEmpty ||
        newPasswordCtrl.text.trim().isEmpty ||
        confirmPasswordCtrl.text.trim().isEmpty) {
      errorToast("all_fields_are_required".tr);
      return false;
    }

    if (newPasswordCtrl.text.length < 6) {
      errorToast("new_password_must_be_at_least_6_characters".tr);
      return false;
    }

    if (currentPasswordCtrl.text == newPasswordCtrl.text) {
      errorToast("new_password_must_be_different_from_current_password".tr);
      return false;
    }

    if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
      errorToast("passwords_do_not_match".tr);
      return false;
    }

    return true;
  }

  // ================= CHANGE PASSWORD =================
  Future<void> changePassword() async {
    if (!validate()) return;

    isLoading.value = true;

    try {
      final response = await repository.changeEmployeePassword(
        currentPassword: currentPasswordCtrl.text.trim(),
        newPassword: newPasswordCtrl.text.trim(),
        confirmPassword: confirmPasswordCtrl.text.trim(),
      );

      final result = ChangePasswordModel.fromJson(response.data);

      if (result.success) {
        successToast(result.message);

        // Clear fields
        currentPasswordCtrl.clear();
        newPasswordCtrl.clear();
        confirmPasswordCtrl.clear();

        // Go back ONLY (no logout)
        Get.back();
      } else {
        errorToast(result.message);
      }
    }

    // ================= DIO ERROR =================
    on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      // 🔴 DO NOT LOGOUT HERE
      if (statusCode == 400 || statusCode == 401) {
        final message = data is Map
            ? (data['error'] ?? data['message'] ?? "invalid_request".tr)
            : "invalid_request".tr;

        errorToast(message);
        return;
      }

      errorToast("something_went_wrong_please_try_again".tr);
    }

    // ================= UNKNOWN ERROR =================
    catch (e) {
      errorToast("unexpected_error_occurred".tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
