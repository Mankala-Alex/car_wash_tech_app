import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/models/profile/change_password_model.dart';
import 'package:my_new_app/app/repositories/profile/profile_repostory.dart';

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
      errorToast("All fields are required");
      return false;
    }

    if (newPasswordCtrl.text.length < 6) {
      errorToast("New password must be at least 6 characters");
      return false;
    }

    if (currentPasswordCtrl.text == newPasswordCtrl.text) {
      errorToast("New password must be different from current password");
      return false;
    }

    if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
      errorToast("Passwords do not match");
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
            ? (data['error'] ?? data['message'] ?? 'Invalid request')
            : 'Invalid request';

        errorToast(message);
        return;
      }

      errorToast("Something went wrong. Please try again.");
    }

    // ================= UNKNOWN ERROR =================
    catch (e) {
      errorToast("Unexpected error occurred");
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
