import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/models/technician_model/booking_model.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/routes/app_routes.dart';

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

      successToast("Work started!");

      // go to Car Status page
      Get.toNamed(
        Routes.carstatus,
        arguments: updatedBooking,
      );
    } catch (e) {
      errorToast("Failed to start work");
    } finally {
      isLoading(false);
    }
  }
}
