import 'package:get/get.dart';
import '../../models/bookings/completed_wash_model.dart';

class TaskCompletedController extends GetxController {
  late CompletedBooking booking;

  @override
  void onInit() {
    booking = Get.arguments as CompletedBooking;
    super.onInit();
  }
}
