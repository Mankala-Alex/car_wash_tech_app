import 'package:get/get.dart';
import 'package:my_new_app/app/models/bookings/history_model.dart';

class ServiceHistoryController extends GetxController {
  late HistoryBookingModel booking;

  @override
  void onInit() {
    booking = Get.arguments as HistoryBookingModel;
    super.onInit();
  }
}
