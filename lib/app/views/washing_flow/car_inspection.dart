import 'dart:io';
import 'package:car_wash_technician/app/helpers/fullscreen_image_view.dart';
import 'package:car_wash_technician/app/helpers/fullscreen_video_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/car_status_controller.dart';
import 'package:car_wash_technician/app/theme/app_theme.dart';

class CarStatusView extends GetView<CarStatusController> {
  const CarStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 🚫 Completely disable back navigation
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "car_inspection".tr,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("service_package".tr,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                          const SizedBox(height: 5),
                          Text(
                            "premium_interior_exterior".tr,
                            style: const TextStyle(
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
              Text(
                "before_wash".tr,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "capture_existing_damage_or_dirt_levels_before_starting".tr,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Obx(() => SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Images
                        ...controller.beforePhotos.asMap().entries.map(
                              (e) => _photoBox(
                                e.value,
                                () => controller.removeBefore(e.key),
                              ),
                            ),

                        // Videos (BESIDE images)
                        ...controller.beforeVideos.map(
                          (file) => _videoBox(
                            file,
                            () => controller.beforeVideos.remove(file),
                          ),
                        ),

                        // Add button
                        if (controller.beforePhotos.length +
                                controller.beforeVideos.length <
                            5)
                          _addPhotoBox(() =>
                              controller.showImageSourceSheet(isBefore: true)),
                      ],
                    ),
                  )),
              const SizedBox(height: 30),
              Text(
                "after_wash".tr,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "show_completed_work_to_verify_quality".tr,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Obx(() => SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Images
                        ...controller.afterPhotos.asMap().entries.map(
                              (e) => _photoBox(
                                e.value,
                                () => controller.removeAfter(e.key),
                              ),
                            ),

                        // Videos
                        ...controller.afterVideos.map(
                          (file) => _videoBox(
                            file,
                            () => controller.afterVideos.remove(file),
                          ),
                        ),

                        // Add button
                        if (controller.afterPhotos.length +
                                controller.afterVideos.length <
                            5)
                          _addPhotoBox(() =>
                              controller.showImageSourceSheet(isBefore: false)),
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
                    : Text(
                        "continue".tr,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // PHOTO BOX (Filled)
  Widget _photoBox(File file, VoidCallback onDelete) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FullscreenImageView(file: file));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 150,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: FileImage(file),
            fit: BoxFit.cover,
          ),
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
      ),
    );
  }

// VIDEO BOX (Preview)
  Widget _videoBox(File file, VoidCallback onDelete) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FullscreenVideoView(file: file));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 150,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black12,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.play_circle_fill,
              size: 50,
              color: Colors.black54,
            ),
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onDelete,
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.camera_alt, color: Colors.black45, size: 35),
              const SizedBox(height: 6),
              Text(
                "add_photo".tr,
                style: const TextStyle(color: Colors.black87),
              ),
              Text(
                "camera_or_gallery".tr,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
