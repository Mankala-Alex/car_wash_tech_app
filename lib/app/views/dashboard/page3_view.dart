import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/dashboard/dashboard_controller.dart';
import 'package:car_wash_technician/app/custome_widgets/custome_confirmation_dialog.dart';
import 'package:car_wash_technician/app/routes/app_routes.dart';
import 'package:car_wash_technician/app/theme/app_theme.dart';

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
        title: Text(
          "my_profile".tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
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
                          ? "technician".tr
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
                                ? "technician".tr
                                : controller.designation.value.capitalizeFirst!,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _statsRow(controller),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const Spacer(),
            // -----------------------------
            // STATS (Rating / Jobs / On-Time)
            // -----------------------------

            // -----------------------------
            // SETTINGS OPTIONS
            // -----------------------------
            _settingsTile(
              "change_language".tr,
              onTap: () {
                Get.toNamed(Routes.langChange);
              },
            ),
            const Divider(),
            _settingsTile(
              "change_password".tr,
              onTap: () {
                Get.toNamed(Routes.changepassword);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.dialog(
                    CustomConfirmationDialog(
                      header: "logout".tr,
                      body: "are_you_sure_you_want_to_logout".tr,
                      yesText: "logout".tr,
                      onYes: () {
                        Get.back();
                        controller.logout();
                      },
                    ),
                    barrierDismissible: false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      "logout".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _statsRow(DashboardController controller) {
    return Row(
      children: [
        _statBox(
          value: "4.8",
          label: "avg_rating".tr,
          icon: Icons.star,
          iconColor: Colors.orange,
        ),
        const SizedBox(width: 10),
        _statBox(
          value: "124",
          label: "jobs_done".tr,
        ),
        const SizedBox(width: 10),
        _statBox(
          value: "98%",
          label: "on_time".tr,
        ),
      ],
    );
  }

  Widget _statBox({
    required String value,
    required String label,
    IconData? icon,
    Color? iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xfffff1dc), // light orange
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 4),
                  Icon(icon, size: 16, color: iconColor),
                ]
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _settingsTile(
  //   String title, {
  //   required VoidCallback onTap,
  // }) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.zero,
  //     dense: true,
  //     visualDensity: const VisualDensity(vertical: -1),
  //     onTap: onTap,
  //     title: Text(
  //       title,
  //       style: const TextStyle(
  //         color: Colors.black,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     trailing: const Icon(
  //       Icons.arrow_forward_ios,
  //       size: 16,
  //       color: Colors.black54,
  //     ),
  //   );
  // }

  Widget _settingsTile(
    String title, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
    );
  }
}
