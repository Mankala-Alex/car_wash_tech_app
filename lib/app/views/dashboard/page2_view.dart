import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/dashboard/dashboard_controller.dart';
import 'package:my_new_app/app/models/bookings/history_model.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/theme/app_theme.dart';

class Page2View extends GetView<DashboardController> {
  const Page2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text(
          "Booking History",
          style: TextStyle(color: Colors.black),
        ),
        //centerTitle: true,
        backgroundColor: AppColors.bgLight,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ---------------- SEARCH ----------------
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              onChanged: (v) => controller.searchText.value = v,
              decoration: InputDecoration(
                hintText: "Search by name, service or booking id",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.borderGray, // normal border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.bgBlackLight, // focused border color
                    width: 1.5,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---------------- LIST ----------------
          Expanded(
            child: Obx(() {
              if (controller.filteredHistory.isEmpty) {
                return const Center(
                  child: Text(
                    "No history found",
                    style: TextStyle(color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredHistory.length,
                itemBuilder: (_, i) {
                  final booking = controller.filteredHistory[i];
                  return _historyCard(booking);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HISTORY CARD
  // ------------------------------------------------------------
  Widget _historyCard(HistoryBookingModel booking) {
    final bool isCompleted = booking.status == "COMPLETED";
    final Color statusColor = isCompleted ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 15, right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------- TIME + STATUS (top small) --------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.scheduledAt != null
                    ? booking.scheduledAt!
                        .toLocal()
                        .toString()
                        .substring(11, 16)
                    : "--",
                style: const TextStyle(
                  color: AppColors.successLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // -------- NAME + IMAGE --------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customerName,
                      style: const TextStyle(
                        color: AppColors.bgBlackLight,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.serviceName,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Amount: ₹${booking.amount}",
                      style: const TextStyle(
                        color: AppColors.errorLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // IMAGE (unchanged)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/car_tech/profile_avatar.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),

          const SizedBox(height: 14),

          // -------- VEHICLE --------
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.black54, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  booking.vehicle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // -------- STATUS TEXT (INSTEAD OF BUTTON) --------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                booking.status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Get.toNamed(
                  Routes.serviceHistory,
                  arguments: booking,
                );
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("View Details"),
            ),
          ),
        ],
      ),
    );
  }
}
