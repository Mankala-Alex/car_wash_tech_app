import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/pre_task_checklist_controller.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/theme/app_theme.dart';

class PreTaskChecklistView extends GetView<PreTaskChecklistController> {
  const PreTaskChecklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        title: const Text(
          "Pre-Task Checklist",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================
            // SERVICE PACKAGE CARD
            // ============================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Service Package",
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54)),
                        SizedBox(height: 5),
                        Text(
                          "Premium Interior & Exterior",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/car_tech/car1.png",
                      width: 90,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Required Items",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ============================
            // REQUIRED ITEMS LIST
            // ============================
            Obx(() => Column(
                  children: controller.items.map((item) {
                    bool isMissing = item["missing"].value;
                    bool checked = item["checked"].value;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:
                            isMissing ? AppColors.primaryLight : Colors.white,
                        borderRadius: BorderRadius.circular(14),
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
                          Row(
                            children: [
                              // CHECKBOX
                              Checkbox(
                                value: checked,
                                activeColor: AppColors.successLight,
                                onChanged: (v) {
                                  item["checked"].value = v!;
                                },
                              ),

                              Expanded(
                                child: Text(
                                  item["name"],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),

                              // MARK AS MISSING
                              if (!isMissing)
                                GestureDetector(
                                  onTap: () {
                                    controller.markAsMissing(item["name"]);
                                  },
                                  child: const Text(
                                    "Mark as Missing",
                                    style: TextStyle(
                                        color: AppColors.bgBlackLight,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),

                          // MISSING ALERT
                          if (isMissing) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.error,
                                          color: AppColors.bgLight, size: 14),
                                      SizedBox(width: 4),
                                      Text("Missing",
                                          style: TextStyle(
                                              color: AppColors.bgLight)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Note: ${item["note"]}",
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    );
                  }).toList(),
                )),

            const SizedBox(height: 25),

            // ============================
            // REPORT MISSING SECTION
            // ============================
            Obx(() {
              if (controller.selectedMissingItem.isEmpty) {
                return const SizedBox();
              }

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    Text(
                      "Report Missing Item: ${controller.selectedMissingItem.value}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please provide a brief note about the issue.",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      onChanged: (v) => controller.reportText.value = v,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.bgLight,
                        hintText: "e.g., Nozzle is cracked",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.cancelMissing,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.confirmMissing,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryLight,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text("Confirm Missing",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            // ============================
            // START WASH BUTTON
            // ============================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.carstatus);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Start Wash",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
