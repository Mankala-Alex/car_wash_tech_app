import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/config/constants.dart';
import 'package:my_new_app/app/controllers/dashboard/service_history_controller.dart';
import 'package:my_new_app/app/theme/app_theme.dart';

class ServiceHistoryView extends GetView<ServiceHistoryController> {
  const ServiceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = controller.booking;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Booking Details",
          //"Booking ${booking.bookingCode}",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _jobStatus(booking.status),
            const SizedBox(height: 20),
            _customerCard(booking),
            const SizedBox(height: 20),
            _vehicleCard(booking),
            const SizedBox(height: 24),
            _imageSection("Before Wash", booking.beforeImages),
            const SizedBox(height: 24),
            _imageSection("After Wash", booking.afterImages),
            const SizedBox(height: 24),
            _serviceSummary(booking),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= JOB STATUS =================
  Widget _jobStatus(String status) {
    final isCompleted = status.toUpperCase() == "COMPLETED";

    return Row(
      children: [
        Expanded(
          child: const Text(
            "Job Status",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.15)
                : Colors.orange.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.access_time,
                color: isCompleted ? Colors.green : Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= CUSTOMER =================
  Widget _customerCard(booking) {
    return _card(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.black12,
            child: Icon(Icons.person, size: 28, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Customer",
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= VEHICLE =================
  Widget _vehicleCard(booking) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vehicle Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            booking.vehicle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            booking.serviceName,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ================= IMAGES =================
  Widget _imageSection(String title, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: images.isEmpty
              ? const Center(child: Text("No images available"))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final path = images[i].replaceAll("\\", "/");
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        Constants.imageBaseUrl + path,
                        width: 260,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ================= SUMMARY =================
  Widget _serviceSummary(booking) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Service Summary",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          _row("Service", booking.serviceName),
          _row("Amount", "₹ ${booking.amount}"),
          _row("Status", booking.status),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$title:",
            style: const TextStyle(color: Colors.black54),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
