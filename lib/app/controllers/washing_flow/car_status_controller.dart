import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/models/technician_model/booking_model.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/repositories/bookings/booking_Image_repository.dart';
import 'package:my_new_app/app/routes/app_routes.dart';

class CarStatusController extends GetxController {
  final ImagePicker picker = ImagePicker();

  final BookingsRepository bookingsRepo = BookingsRepository();
  final BookingImageRepository imageRepo = BookingImageRepository();

  late BookingModel booking;

  final beforePhotos = <File>[].obs;
  final afterPhotos = <File>[].obs;

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
              title: const Text("Camera"),
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
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                _pickImage(
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
      await imageRepo.uploadImages(
        bookingId: booking.id,
        employeeId: empId,
        imageType: "BEFORE",
        images: beforePhotos,
      );
      return true;
    } catch (e) {
      final errorMsg = 'Before images: ${e.toString()}';
      errorToast(errorMsg);
      return false;
    }
  }

  Future<bool> uploadAfterImages() async {
    if (afterPhotos.isEmpty) return true;

    final empId = await SharedPrefsHelper.getString("employeeId");

    try {
      await imageRepo.uploadImages(
        bookingId: booking.id,
        employeeId: empId,
        imageType: "AFTER",
        images: afterPhotos,
      );
      return true;
    } catch (e) {
      final errorMsg = 'After images: ${e.toString()}';
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
        errorToast("Please upload before & after images");
        return;
      }

      final beforeOk = await uploadBeforeImages();
      if (!beforeOk) {
        errorToast("Failed to upload before images");
        return;
      }

      final afterOk = await uploadAfterImages();
      if (!afterOk) {
        errorToast("Failed to upload after images");
        return;
      }

      successToast("Images uploaded successfully!");
      Get.toNamed(Routes.paymentScreen, arguments: booking);
    } catch (e) {
      errorToast("Something went wrong");
    } finally {
      // ✅ THIS ALWAYS RUNS
      isLoading(false);
    }
  }
}
