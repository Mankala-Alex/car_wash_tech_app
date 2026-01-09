import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/dashboard/dashboard_controller.dart';
import 'package:my_new_app/app/custome_widgets/custome_confirmation_dialog.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/theme/app_theme.dart';

class Page3View extends GetView<DashboardController> {
  const Page3View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange,
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/car_tech/profile_avatar.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            size: 18, color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() => Text(
                      controller.employeeName.value.isEmpty
                          ? "Technician"
                          : controller.employeeName.value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    )),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xffffe7c3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.workspace_premium,
                          color: Colors.orange, size: 18),
                      const SizedBox(width: 5),
                      Obx(() => Text(
                            controller.designation.value.isEmpty
                                ? "Technician"
                                : controller.designation.value.capitalizeFirst!,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),

            // -----------------------------
            // STATS (Rating / Jobs / On-Time)
            // -----------------------------

            Spacer(),
            // -----------------------------
            // SETTINGS OPTIONS
            // -----------------------------

            _settingsTile(
              "Change Language",
              onTap: () {
                Get.toNamed(Routes.langChange);
              },
            ),
            const Divider(),
            _settingsTile(
              "Change Password",
              onTap: () {
                Get.toNamed(Routes.changepassword);
              },
            ),
            const Divider(),

            _settingsTile(
              "Log Out",
              isLogout: true,
              onTap: () {
                Get.dialog(
                  CustomConfirmationDialog(
                    header: "Logout",
                    body: "Are you sure you want to logout?",
                    yesText: "Logout",
                    onYes: () {
                      Get.back();
                      controller.logout();
                    },
                  ),
                  barrierDismissible: false,
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(
    String title, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: isLogout
          ? const Icon(Icons.logout, color: Colors.red)
          : const Icon(Icons.arrow_forward_ios, size: 18),
    );
  }
}
