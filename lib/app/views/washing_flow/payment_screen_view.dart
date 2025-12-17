import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/payment_screen_controller.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/theme/app_theme.dart';

class PaymentScreenView extends GetView<PaymentScreenController> {
  const PaymentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight, // light grey like your image

      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0.4,
        title: const Text(
          "Payment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==========================
            // CUSTOMER + AMOUNT CARD
            // ==========================
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Customer: John Doe",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Amount to Collect",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "₹ 750",
                      style: TextStyle(
                        color: AppColors.successLight,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      decoration: BoxDecoration(
                        color: controller.isPaid.value
                            ? AppColors.successLight
                            : Colors.redAccent.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        controller.isPaid.value
                            ? "Payment Completed"
                            : "Payment Pending",
                        style: TextStyle(
                          color: controller.isPaid.value
                              ? AppColors.textWhiteLight
                              : AppColors.errorLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // UPI PAYMENT CARD
            // ==========================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  const Row(
                    children: [
                      Icon(Icons.qr_code_rounded,
                          size: 22, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "UPI Payment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.volume_up_rounded,
                          size: 22, color: Colors.grey),
                    ],
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    "Scan QR to pay",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),

                  const SizedBox(height: 18),

                  // QR IMAGE
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/car_tech/qr.png",
                        width: 220,
                        height: 220,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "UPI ID",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.borderLightGrayLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "john.doe@upi",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(Icons.copy, color: Colors.black87),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Supported by GPay, PhonePe, Paytm",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================
            // CASH RECEIVED BUTTON
            // ==========================
            // ==========================
// CASH RECEIVED BUTTON (NOW FUNCTIONS AS MARK PAID)
// ==========================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(
                () => OutlinedButton(
                  onPressed: controller.isPaid.value
                      ? null
                      : () {
                          controller.markPaid();
                        },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: controller.isPaid.value
                          ? Colors.green
                          : Colors.black12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    controller.isPaid.value
                        ? "Cash Received ✓"
                        : "Cash Received  💵",
                    style: TextStyle(
                      color: controller.isPaid.value
                          ? Colors.green
                          : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // PROCEED BUTTON
            // ==========================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to summary screen
                  Get.toNamed(Routes.taskCompleted);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Proceed to Summary",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
