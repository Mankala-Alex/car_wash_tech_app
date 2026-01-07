import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/car_status_controller.dart';
import 'package:my_new_app/app/theme/app_theme.dart';

class CarStatusView extends GetView<CarStatusController> {
  const CarStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Car Inspection",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.bgBlackLight,
                  width: 1.5,
                ),
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
            const SizedBox(height: 24),
            const Text(
              "Before Wash",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Capture existing damage or dirt levels before starting.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...controller.beforePhotos.asMap().entries.map(
                            (e) => _photoBox(
                                e.value, () => controller.removeBefore(e.key)),
                          ),
                      if (controller.beforePhotos.length < 5)
                        _addPhotoBox(() =>
                            controller.showImageSourceSheet(isBefore: true))
                    ],
                  ),
                )),
            const SizedBox(height: 30),
            const Text(
              "After Wash",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Show completed work to verify quality.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...controller.afterPhotos.asMap().entries.map(
                            (e) => _photoBox(
                                e.value, () => controller.removeAfter(e.key)),
                          ),
                      if (controller.afterPhotos.length < 5)
                        _addPhotoBox(() =>
                            controller.showImageSourceSheet(isBefore: false))
                    ],
                  ),
                )),
            const SizedBox(height: 50),
          ],
        ),
      ),

      // Submit Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final canContinue = controller.beforePhotos.isNotEmpty &&
              controller.afterPhotos.isNotEmpty &&
              !controller.isLoading.value;

          return SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed:
                  canContinue ? () => controller.continueToPayment() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  // PHOTO BOX (Filled)
  Widget _photoBox(File file, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 150,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: onDelete,
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ADD PHOTO BOX (Light theme)
  Widget _addPhotoBox(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black26,
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, color: Colors.black45, size: 35),
              SizedBox(height: 6),
              Text(
                "Add Photo",
                style: TextStyle(color: Colors.black87),
              ),
              Text(
                "Camera or Gallery",
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
