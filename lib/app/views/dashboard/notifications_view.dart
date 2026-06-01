import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/dashboard/notifications_controller.dart';
import 'package:car_wash_technician/app/theme/app_theme.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
        centerTitle: true,
        title: Text(
          "notifications".tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearAll();
            },
            child: Text(
              "clear".tr,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notificationCard(
            icon: Icons.local_car_wash,
            title: "new_task_assigned".tr,
            message: "premium_wash_bay3".tr,
            time: "2m ago",
            unread: true,
          ),
          _notificationCard(
            icon: Icons.chat_bubble_outline,
            title: "message_from_admin".tr,
            message: "check_inventory_soap".tr,
            time: "12m ago",
            unread: true,
          ),
          _notificationCard(
            icon: Icons.location_on,
            title: "task_updated".tr,
            message: "location_moved_sector4".tr,
            time: "45m ago",
          ),
          _notificationCard(
            icon: Icons.access_time,
            title: "reminder_upcoming_task".tr,
            message: "scheduled_start_in_15_mins".tr,
            time: "1h ago",
          ),
          const SizedBox(height: 24),
          Text(
            "yesterday".tr,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _notificationCard(
            icon: Icons.settings,
            title: "system_update".tr,
            message: "version_240_live".tr,
            time: "20h ago",
          ),
          _notificationCard(
            icon: Icons.payments,
            title: "commission_paid".tr,
            message: "commission_paid_msg".tr,
            time: "yesterday".tr,
          ),
        ],
      ),
    );
  }

  // ================= NOTIFICATION CARD =================
  Widget _notificationCard({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    bool unread = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: unread
            ? const Border(
                left: BorderSide(
                  color: Colors.orange,
                  width: 4,
                ),
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xfffff1dc),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
