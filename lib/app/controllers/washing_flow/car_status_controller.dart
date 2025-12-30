import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_new_app/app/controllers/dashboard/dashboard_controller.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/models/bookings/completed_wash_model.dart';
import 'package:my_new_app/app/models/technician_model/booking_model.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/routes/app_routes.dart';

class CarStatusController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final BookingsRepository repository = BookingsRepository();

  late BookingModel booking; // 🔥 coming from task_details startWork()
  var beforePhotos = <File>[].obs;
  var afterPhotos = <File>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    booking = Get.arguments as BookingModel;
    super.onInit();
  }

  // ---------------------- IMAGE PICKERS ----------------------
  Future<void> pickBeforeImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      beforePhotos.add(File(image.path));
    }
  }

  Future<void> pickAfterImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      afterPhotos.add(File(image.path));
    }
  }

  void removeBefore(int index) => beforePhotos.removeAt(index);
  void removeAfter(int index) => afterPhotos.removeAt(index);

  // ---------------------- COMPLETE BOOKING API ----------------------
  Future<void> completeBooking() async {
    try {
      isLoading(true);

      final empId = await SharedPrefsHelper.getString("employeeId");

      final Map<String, dynamic> payload = {
        "booking_id": booking.id,
        "employee_id": empId,
        "before_images": [], // you can upload images later
        "after_images": [],
      };

      final response = await repository.postCompleteBooking(payload);
      final model = Completedwashmodel.fromJson(response.data);

      if (model.booking == null) {
        errorToast("Failed to complete booking");
        return;
      }

      successToast("Task Completed Successfully!");
      final dashboard = Get.find<DashboardController>();
      await dashboard.fetchPendingBookings();
      await dashboard.fetchBookingHistory();
      dashboard.calculateSummary();
      // Navigate to payment or success page
      Get.offAllNamed(
        Routes.paymentScreen,
        arguments: model.booking,
      );
    } catch (e) {
      errorToast("Failed to complete booking");
    } finally {
      isLoading(false);
    }
  }
}
