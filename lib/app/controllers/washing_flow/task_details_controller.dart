import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/models/bookings/accept_booking_model.dart';
import 'package:my_new_app/app/models/bookings/start_wash_model.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/routes/app_routes.dart';

class TaskDetailsController extends GetxController {
  final BookingsRepository repository = BookingsRepository();

  late AcceptedBooking booking;
  var isLoading = false.obs;

  @override
  void onInit() {
    booking = Get.arguments as AcceptedBooking;
    super.onInit();
  }

  Future<void> startWork() async {
    try {
      isLoading(true);

      final empId = await SharedPrefsHelper.getString("employeeId");

      final response = await repository.postStartWashing({
        "booking_id": booking.id,
        "employee_id": empId,
      });

      final model = Startwashmodel.fromJson(response.data);

      if (model.booking == null) {
        errorToast("Failed to start work");
        return;
      }

      successToast("Work started");

      // NEXT STEP SCREEN
      Get.toNamed(
        Routes.custLocation,
        arguments: model.booking,
      );
    } catch (e) {
      errorToast("Failed to start work");
    } finally {
      isLoading(false);
    }
  }
}
