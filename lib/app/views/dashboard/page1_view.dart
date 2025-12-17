import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/theme/app_theme.dart';
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

            // -------------------------------
            // UP NEXT CARD
            // -------------------------------
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Up Next",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        const Text(
                          "John Doe - Premium Wash",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        const Text("10:00 AM",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.taskDetails);
                            },
                            child: const Text(
                              "View Details",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ))
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
            ),

            const SizedBox(height: 20),

            // -------------------------------
            // START DAY BUTTON
            // -------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.alltasks);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.secondaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Start Day",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "All Tasks",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),

            const SizedBox(height: 15),

            // -------------------------------
            // TASKS LIST
            // -------------------------------
            _taskCard(
              name: "John Doe",
              service: "Premium Wash",
              time: "10:00 AM",
              vehicle: "SUV",
              status: "Pending",
              color: Colors.orange,
            ),

            _taskCard(
              name: "Jane Smith",
              service: "Interior Detail",
              time: "11:30 AM",
              vehicle: "Sedan",
              status: "In Progress",
              color: Colors.blue,
            ),

            _taskCard(
              name: "Mike Williams",
              service: "Standard Wash",
              time: "1:00 PM",
              vehicle: "Truck",
              status: "Completed",
              color: Colors.green,
            ),
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

  // ------------------------------------------------------------
  // TASK CARD (with white + shadow)
  // ------------------------------------------------------------
  Widget _taskCard({
    required String name,
    required String service,
    required String time,
    required String vehicle,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(service,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(time, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 15),
                    const Icon(Icons.directions_car,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(vehicle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
