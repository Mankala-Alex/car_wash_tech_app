import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/custome_widgets/custome_confirmation_dialog.dart';
import 'package:car_wash_technician/app/models/technician_model/booking_model.dart';
import 'package:car_wash_technician/app/routes/app_routes.dart';
import 'package:car_wash_technician/app/theme/app_theme.dart';
import '../../controllers/dashboard/dashboard_controller.dart';

class Page1View extends GetView<DashboardController> {
  const Page1View({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage("assets/car_tech/profile_avatar.png"),
            ),
            const SizedBox(width: 12),

            // Name + Greeting
            Obx(
              () => Text(
                controller.employeeName.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.notifications);
                },
                icon: const Icon(Icons.notifications_none,
                    color: Colors.black, size: 28),
              )),
        ],
      ),

      // ============================
      // BODY CONTENT
      // ============================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------
            // SUMMARY CARD SECTION
            // -------------------------------
            Obx(
              () => Container(
                width: screenWidth,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "todays_summary".tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _summaryBox(
                            title: "total_jobs".tr,
                            value: controller.todaysTotalJobs.value.toString()),
                        const SizedBox(width: 12),
                        _summaryBox(
                            title: "earnings".tr,
                            value: "₹${controller.todaysEarnings.value}")
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _summaryBox(
                            title: "pending".tr,
                            value: controller.todaysPending.value.toString()),
                        const SizedBox(width: 12),
                        _summaryBox(
                            title: "completed".tr,
                            value: controller.todaysCompleted.value.toString())
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "todays_tasks".tr,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(height: 15),
            Obx(() {
              if (controller.todaysTasks.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/no_data/no_tasks.png",
                        height: 300,
                        width: 300,
                      ),
                      Text("no_tasks_available".tr,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }

              return Column(
                children: controller.todaysTasks.map((task) {
                  return _todayTaskCard(task);
                }).toList(),
              );
            }),

            const SizedBox(height: 20),
            Text(
              "pending_tasks".tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 15),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.pendingBookings.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/no_data/no_pending_tasks.jpg",
                        height: 300,
                        width: 300,
                      ),
                      Text("no_pending_tasks_available".tr,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }

              return Column(
                children: controller.pendingBookings.map((booking) {
                  return _pendingBookingCard(controller, booking);
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SUMMARY BOX (with bgLight color + shadow)
  // ------------------------------------------------------------
  Widget _summaryBox({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todayTaskCard(BookingModel booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          // STATUS BADGE
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                booking.status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customerName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      booking.serviceName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      booking.vehicle,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      booking.scheduledAt != null
                          ? booking.scheduledAt!
                              .toLocal()
                              .toString()
                              .substring(11, 16)
                          : "--",
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/car_tech/profile_avatar.png",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          // START WORK BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(
                  Routes.custLocation,
                  arguments: booking, // type = BookingModel
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryLight,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "start_work".tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendingBookingCard(
      DashboardController controller, BookingModel booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.customerName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            booking.serviceName,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            booking.scheduledAt != null
                ? booking.scheduledAt!.toLocal().toString().substring(0, 10)
                : "--",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                booking.scheduledAt != null
                    ? booking.scheduledAt!
                        .toLocal()
                        .toString()
                        .substring(11, 16)
                    : "--",
              ),
              const SizedBox(width: 15),
              const Icon(Icons.directions_car, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(booking.vehicle),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    Get.dialog(
                      CustomConfirmationDialog(
                        header: "reject_booking".tr,
                        body: "are_you_sure_you_want_to_reject_this_booking".tr,
                        yesText: "yes_reject".tr,
                        noText: "no".tr,
                        onYes: () async {
                          Get.back(); // close dialog first
                          await controller.rejectBooking(booking);
                        },
                        onNo: () {
                          Get.back(); // close dialog
                        },
                      ),
                      barrierDismissible: false, // user must choose Yes/No
                    );
                  },
                  child: Text(
                    "reject".tr,
                    style: const TextStyle(color: AppColors.errorLight),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.acceptBooking(booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successLight,
                  ),
                  child: Text("accept".tr),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
