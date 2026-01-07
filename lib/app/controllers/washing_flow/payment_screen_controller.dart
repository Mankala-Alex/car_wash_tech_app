import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/models/bookings/completed_wash_model.dart';
import 'package:my_new_app/app/models/technician_model/booking_model.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/routes/app_routes.dart';

class PaymentScreenController extends GetxController {
  final BookingsRepository repository = BookingsRepository();

  late BookingModel booking;

  var isPaid = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    booking = Get.arguments as BookingModel;
    super.onInit();
  }

  void markPaid() {
    isPaid.value = true;
  }

  Future<void> completeWash() async {
    if (!isPaid.value) {
      errorToast("Please collect payment first");
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

      final result = Completedwashmodel.fromJson(response.data);

      if (result.success && result.booking != null) {
        successToast("Wash completed successfully");

        Get.offAllNamed(
          Routes.taskCompleted,
          arguments: result.booking,
        );
      } else {
        errorToast("Failed to complete wash");
      }
    } catch (e) {
      errorToast("Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}
