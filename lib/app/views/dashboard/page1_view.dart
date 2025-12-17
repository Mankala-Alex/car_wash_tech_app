import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/models/bookings/accept_booking_model.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/theme/app_theme.dart';
import '../../controllers/dashboard/dashboard_controller.dart';
import '../../models/bookings/pending_bookings_model.dart';

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
        title: const Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage("assets/car_tech/profile_avatar.png"),
            ),
            SizedBox(width: 12),

            // Name + Greeting
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning,",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "Alex Mitchell",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child:
                Icon(Icons.notifications_none, color: Colors.black, size: 28),
          ),
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
            Container(
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
                  const Text(
                    "Today's Summary",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _summaryBox(title: "TOTAL JOBS", value: "5"),
                      const SizedBox(width: 12),
                      _summaryBox(title: "EARNINGS", value: "\$120"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _summaryBox(title: "PENDING", value: "2"),
                      const SizedBox(width: 12),
                      _summaryBox(title: "COMPLETED", value: "3"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Todays Tasks",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(height: 15),
            Obx(() {
              if (controller.todaysTasks.isEmpty) {
                return const Text(
                  "No assigned tasks yet",
                  style: TextStyle(color: Colors.black54),
                );
              }

              return Column(
                children: controller.todaysTasks.map((task) {
                  return _todayTaskCard(task);
                }).toList(),
              );
            }),

            const SizedBox(height: 20),
            const Text(
              "Pending Tasks",
              style: TextStyle(
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
                return const Text("No pending bookings");
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

  Widget _todayTaskCard(AcceptedBooking booking) {
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
                      "${booking.customerName}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${booking.serviceName}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${booking.vehicle}",
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
                  Routes.taskDetails,
                  arguments: booking,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryLight,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Start Work",
                style: TextStyle(
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
      DashboardController controller, PendingBooking booking) {
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
          Text(
            booking.serviceName,
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
                  onPressed: () => controller.rejectBooking(booking),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text("Reject"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.acceptBooking(booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successLight,
                  ),
                  child: const Text("Accept"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
