import 'package:get/get.dart';
import 'package:car_wash_technician/app/helpers/shared_preferences.dart';
import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
import 'package:car_wash_technician/app/models/technician_model/booking_model.dart';
import 'package:car_wash_technician/app/repositories/bookings/bookings_repository.dart';
import 'package:car_wash_technician/app/routes/app_routes.dart';

class TaskDetailsController extends GetxController {
  final BookingsRepository repository = BookingsRepository();

  late BookingModel booking; // <— SINGLE MODEL
  var isLoading = false.obs;

  @override
  void onInit() {
    booking = Get.arguments as BookingModel;
    super.onInit();
  }

  Future<void> startWork() async {
    try {
      isLoading(true);

      final empId = await SharedPrefsHelper.getString("employeeId");

      final payload = {
        "booking_id": booking.id,
        "employee_id": empId,
      };

      final response = await repository.postStartWashing(payload);

      // Convert to BookingModel
      final updatedBooking = BookingModel.fromJson(response.data["booking"]);

      successToast("work_started".tr);

      // go to Car Status page
      Get.toNamed(
        Routes.carstatus,
        arguments: updatedBooking,
      );
    } catch (e) {
      errorToast("failed_to_start_work".tr);
    } finally {
      isLoading(false);
    }
  }
}
