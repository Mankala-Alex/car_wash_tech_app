import 'dart:io';

import 'package:get/get.dart';
import 'package:car_wash_technician/app/helpers/shared_preferences.dart';
import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
import 'package:car_wash_technician/app/models/bookings/completed_wash_model.dart';
import 'package:car_wash_technician/app/models/technician_model/booking_model.dart';
import 'package:car_wash_technician/app/repositories/bookings/bookings_repository.dart';
import 'package:car_wash_technician/app/repositories/bookings/booking_image_repository.dart';
import 'package:car_wash_technician/app/routes/app_routes.dart';

class PaymentScreenController extends GetxController {
  final BookingsRepository repository = BookingsRepository();
  final BookingImageRepository imageRepo = BookingImageRepository();

  late BookingModel booking;

  var isPaid = false.obs;
  var isLoading = false.obs;

  /// images (set these from previous screen)
  List<File> beforeImages = [];
  List<File> afterImages = [];

  @override
  void onInit() {
    super.onInit();
    booking = Get.arguments as BookingModel;
  }

  void markPaid() {
    isPaid.value = true;
  }

  Future<void> completeWash() async {
    if (!isPaid.value) {
      errorToast("please_collect_payment_first".tr);
      return;
    }

    try {
      isLoading(true);

      final empId = await SharedPrefsHelper.getString("employeeId");

      final body = {
        "booking_id": booking.id,
        "employee_id": empId,
      };

      final response = await repository.postCompleteWash(body);

      if (response.data == null) {
        errorToast("failed_to_complete_wash".tr);
        return;
      }

      final result = Completedwashmodel.fromJson(response.data);

      if (result.success && result.booking != null) {
        successToast("wash_completed_successfully".tr);
        Get.offAllNamed(
          Routes.taskCompleted,
          arguments: result.booking,
        );
      } else {
        errorToast("failed_to_complete_wash".tr);
      }
    } catch (e) {
      errorToast(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
