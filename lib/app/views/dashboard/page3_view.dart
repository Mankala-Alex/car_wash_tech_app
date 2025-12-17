import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/dashboard/dashboard_controller.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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

            const SizedBox(height: 25),

            // -----------------------------
            // STATS (Rating / Jobs / On-Time)
            // -----------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox("4.8", "Avg Rating", Icons.star, Colors.orange),
                _statBox("124", "Jobs Done", Icons.build),
                _statBox("98%", "On-Time", Icons.timelapse),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.badge, "EMPLOYEE ID", "#CW-8821"),
                  const Divider(),
                  _infoRow(Icons.phone, "PHONE", "(555) 123-4567"),
                  const Divider(),
                  _infoRow(Icons.directions_car, "VEHICLE",
                      "Ford Transit (ABC-123)"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // -----------------------------
            // EDIT PROFILE BUTTON
            // -----------------------------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // -----------------------------
            // SETTINGS OPTIONS
            // -----------------------------
            _settingsTile("Notifications"),
            _settingsTile("Change Password"),
            _settingsTile("Log Out", isLogout: true),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------
  // COMPONENT: STATS
  // -----------------------------------------
  Widget _statBox(String value, String label, IconData icon, [Color? color]) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xfffff2e0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: color ?? Colors.black54),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------
  // COMPONENT: PERSONAL INFO ROW
  // -----------------------------------------
  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xfffff2e0),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }

  // -----------------------------------------
  // COMPONENT: SETTINGS TILE
  // -----------------------------------------
  Widget _settingsTile(String title, {bool isLogout = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
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
