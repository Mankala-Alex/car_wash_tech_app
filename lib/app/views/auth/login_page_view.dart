import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/auth/login_controller.dart';
import 'package:car_wash_technician/app/theme/app_theme.dart';

class LoginPageView extends GetView<LoginController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // -----------------------------
              // Logo Section
              // -----------------------------
              Center(
                child: Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight, // light blue background
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_car_wash_rounded,
                      color: AppColors.secondaryLight,
                      size: 42,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // -----------------------------
              // Welcome Text
              // -----------------------------
              Center(
                child: Text(
                  "welcome_back".tr,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "enter_your_credentials_to_login_into_the_technician_app".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 45),

              // -----------------------------
              // Employee ID
              // -----------------------------
              Text(
                "employee_id".tr,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: controller.employeeIdController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge_rounded),
                  hintText: "enter_your_employee_id".tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // -----------------------------
              // Password
              // -----------------------------
              Text(
                "password".tr,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.passwordController,
                obscureText: !controller.showPassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_rounded),
                  suffixIcon: Obx(
                    () => IconButton(
                      icon: Icon(
                        controller.showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: controller.showPassword.toggle,
                    ),
                  ),
                  hintText: "enter_your_password".tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "forgot_password".tr,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // -----------------------------
              // Login Button
              // -----------------------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "login".tr,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
