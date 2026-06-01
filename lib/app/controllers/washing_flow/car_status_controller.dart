import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
import 'package:car_wash_technician/app/helpers/shared_preferences.dart';
import 'package:car_wash_technician/app/models/technician_model/booking_model.dart';
import 'package:car_wash_technician/app/repositories/bookings/bookings_repository.dart';
import 'package:car_wash_technician/app/repositories/bookings/booking_Image_repository.dart';
import 'package:car_wash_technician/app/routes/app_routes.dart';

class CarStatusController extends GetxController {
  final ImagePicker picker = ImagePicker();

  final BookingsRepository bookingsRepo = BookingsRepository();
  final BookingImageRepository imageRepo = BookingImageRepository();

  late BookingModel booking;

  final beforePhotos = <File>[].obs;
  final afterPhotos = <File>[].obs;
  final beforeVideos = <File>[].obs;
  final afterVideos = <File>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    booking = Get.arguments as BookingModel;
    super.onInit();
  }

// ================= IMAGE PICK =================

  Future<void> _pickImage({
    required ImageSource source,
    required bool isBefore,
  }) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image == null) return;

    final file = File(image.path);

    if (isBefore) {
      beforePhotos.add(file);
    } else {
      afterPhotos.add(file);
    }
  }

  Future<void> _pickVideo({
    required ImageSource source,
    required bool isBefore,
  }) async {
    final XFile? video = await picker.pickVideo(source: source);

    if (video == null) return;

    final file = File(video.path);

    if (isBefore) {
      beforeVideos.add(file);
    } else {
      afterVideos.add(file);
    }
  }

  void showImageSourceSheet({required bool isBefore}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text("camera".tr),
              onTap: () {
                Get.back();
                _pickImage(
                  source: ImageSource.camera,
                  isBefore: isBefore,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text("gallery".tr),
              onTap: () {
                Get.back();
                _pickImage(
                  source: ImageSource.gallery,
                  isBefore: isBefore,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text("record_video".tr),
              onTap: () {
                Get.back();
                _pickVideo(
                  source: ImageSource.camera,
                  isBefore: isBefore,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: Text("pick_video".tr),
              onTap: () {
                Get.back();
                _pickVideo(
                  source: ImageSource.gallery,
                  isBefore: isBefore,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeBefore(int index) => beforePhotos.removeAt(index);
  void removeAfter(int index) => afterPhotos.removeAt(index);

  // ================= UPLOAD HELPERS =================

  Future<bool> uploadBeforeImages() async {
    if (beforePhotos.isEmpty) return true;

    final empId = await SharedPrefsHelper.getString("employeeId");

    try {
      await imageRepo.uploadMedia(
        bookingId: booking.id,
        employeeId: empId,
        imageType: "BEFORE",
        videoType: "BEFORE", // ✅ THIS IS REQUIRED
        images: beforePhotos,
        videos: beforeVideos,
      );

      return true;
    } catch (e) {
      final errorMsg = '${"before_images_error".tr} ${e.toString()}';
      errorToast(errorMsg);
      return false;
    }
  }

  Future<bool> uploadAfterImages() async {
    if (afterPhotos.isEmpty) return true;

    final empId = await SharedPrefsHelper.getString("employeeId");

    try {
      await imageRepo.uploadMedia(
        bookingId: booking.id,
        employeeId: empId,
        imageType: "AFTER",
        videoType: "AFTER", // ✅ THIS IS REQUIRED
        images: afterPhotos,
        videos: afterVideos,
      );

      return true;
    } catch (e) {
      final errorMsg = '${"after_images_error".tr} ${e.toString()}';
      errorToast(errorMsg);
      return false;
    }
  }

  // ================= CONTINUE TO PAYMENT (UPLOAD IMAGES ONLY) =================
  /// This method is called from the Continue button on Car Inspection screen.
  /// It ONLY uploads the before and after images, then navigates to Payment screen.
  /// The booking completion happens from the Payment screen, NOT here.
  Future<void> continueToPayment() async {
    if (isLoading.value) return;

    isLoading(true);

    try {
      if (beforePhotos.isEmpty || afterPhotos.isEmpty) {
        errorToast("please_upload_before_after_images".tr);
        return;
      }

      final beforeOk = await uploadBeforeImages();
      if (!beforeOk) {
        errorToast("failed_to_upload_before_images".tr);
        return;
      }

      final afterOk = await uploadAfterImages();
      if (!afterOk) {
        errorToast("failed_to_upload_after_images".tr);
        return;
      }

      successToast("images_uploaded_successfully".tr);
      Get.toNamed(Routes.paymentScreen, arguments: booking);
    } catch (e) {
      errorToast("something_went_wrong".tr);
    } finally {
      // ✅ THIS ALWAYS RUNS
      isLoading(false);
    }
  }
}
