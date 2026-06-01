import 'package:get/get.dart';
import 'package:car_wash_technician/app/helpers/shared_preferences.dart';
import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
import 'package:car_wash_technician/app/models/technician_model/booking_model.dart';
import 'package:car_wash_technician/app/repositories/bookings/bookings_repository.dart';
import 'package:car_wash_technician/app/routes/app_routes.dart';

class CustLocationController extends GetxController {
  final BookingsRepository repository = BookingsRepository();

  late BookingModel booking; // <— SINGLE MODEL
  var isLoading = false.obs;

  @override
  void onInit() {
    booking = Get.arguments as BookingModel;
    super.onInit();
  }

  Future<void> markArrived() async {
    try {
      isLoading(true);

      final empId = await SharedPrefsHelper.getString("employeeId");

      final body = {
        "booking_id": booking.id,
        "employee_id": empId,
      };

      final response = await repository.postArrivedBooking(body);

      // convert API response into BookingModel
      final updatedBooking = BookingModel.fromJson(response.data["booking"]);

      successToast("arrived_confirmed".tr);

      // Navigate to Task Details with updated booking
      Get.toNamed(
        Routes.taskDetails,
        arguments: updatedBooking,
      );
    } catch (e) {
      errorToast("failed_to_mark_arrival".tr);
    } finally {
      isLoading(false);
    }
  }
}
