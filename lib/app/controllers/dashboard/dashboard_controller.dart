import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/models/bookings/accept_booking_model.dart';
import 'package:my_new_app/app/models/bookings/history_model.dart';
import 'package:my_new_app/app/models/bookings/reject_booking_model.dart';
import 'package:my_new_app/app/services/api_service.dart';
import 'package:my_new_app/app/services/endpoints.dart';
import '../../models/bookings/pending_bookings_model.dart';
import '../../repositories/bookings/bookings_repository.dart';
import '../../helpers/flutter_toast.dart';

class DashboardController extends GetxController {
  final BookingsRepository repository = BookingsRepository();

  var selectedIndex = 0.obs;
  var pendingBookings = <PendingBooking>[].obs;
  var todaysTasks = <AcceptedBooking>[].obs;

  var isLoading = false.obs;
  RxString employeeName = ''.obs;
  RxString designation = ''.obs;
  RxString employeeId = ''.obs;

  // HISTORY
  var historyBookings = <HistoryBookingModel>[].obs;
  var searchText = "".obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    loadEmployeeData();
    fetchPendingBookings();
    fetchBookingHistory();
    super.onInit();
  }

  Future<void> loadEmployeeData() async {
    employeeName.value = await SharedPrefsHelper.getString("employeeName");

    designation.value =
        await SharedPrefsHelper.getString("employeeDesignation");
  }

  Future<void> fetchPendingBookings() async {
    try {
      isLoading(true);
      final response = await repository.getApiPendingBokkings();
      final model = Pendingbookingsmodel.fromJson(response.data);
      pendingBookings.assignAll(model.bookings);
    } catch (e) {
      errorToast("Failed to load bookings");
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptBooking(PendingBooking booking) async {
    try {
      final empId = await SharedPrefsHelper.getString("employeeId");
      final empName = await SharedPrefsHelper.getString("employeeName");

      final response = await repository.postAcceptBooking({
        "booking_id": booking.id,
        "employee_id": empId,
        "employee_name": empName,
      });

      final model = Acceptbookingmodel.fromJson(response.data);

      if (model.booking == null) return;

      // 1️⃣ Remove from pending
      pendingBookings.removeWhere((b) => b.id == booking.id);

      // 2️⃣ Add to today's tasks (ASSIGNED)
      todaysTasks.add(model.booking!);

      successToast("Task assigned");
    } catch (e) {
      errorToast("Failed to accept booking");
    }
  }

  Future<void> rejectBooking(PendingBooking booking) async {
    try {
      final empId = await SharedPrefsHelper.getString("employeeId");

      await repository.postRejectBooking({
        "booking_id": booking.id,
        "employee_id": empId,
      });

      pendingBookings.removeWhere((b) => b.id == booking.id);
      successToast("Booking rejected");
    } catch (e) {
      errorToast("Failed to reject booking");
    }
  }

  // filtered list
  List<HistoryBookingModel> get filteredHistory {
    if (searchText.value.isEmpty) return historyBookings;

    return historyBookings.where((b) {
      final q = searchText.value.toLowerCase();
      return b.customerName.toLowerCase().contains(q) ||
          b.serviceName.toLowerCase().contains(q) ||
          b.bookingCode.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> fetchBookingHistory() async {
    try {
      final employeeId = await SharedPrefsHelper.getString("employeeId");

      if (employeeId.isEmpty) return;

      isLoading(true);

      final response = await repository.getApiBookingHistory(
        query: {"employee_id": employeeId},
      );

      final model = Historymodel.fromJson(response.data);
      historyBookings.assignAll(model.bookings);

      print("✅ History loaded: ${model.bookings.length}");
    } catch (e) {
      errorToast("Failed to load booking history");
      print("❌ History error: $e");
    } finally {
      isLoading(false);
    }
  }
}
