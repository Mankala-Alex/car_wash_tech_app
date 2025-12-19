import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/models/technician_model/booking_model.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/models/bookings/history_model.dart';

class DashboardController extends GetxController {
  final BookingsRepository repository = BookingsRepository();

  var todaysTotalJobs = 0.obs;
  var todaysPending = 0.obs;
  var todaysCompleted = 0.obs;
  var todaysEarnings = 0.obs;

  var selectedIndex = 0.obs;
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  // USING SINGLE MODEL
  var pendingBookings = <BookingModel>[].obs;
  var todaysTasks = <BookingModel>[].obs;

  var isLoading = false.obs;
  RxString employeeName = ''.obs;
  RxString designation = ''.obs;

  // HISTORY
  var historyBookings = <HistoryBookingModel>[].obs;
  var searchText = "".obs;

  @override
  void onInit() {
    loadEmployeeData();
    fetchPendingBookings().then((_) => calculateSummary());
    fetchBookingHistory().then((_) => calculateSummary());
    super.onInit();
  }

  void calculateSummary() {
    DateTime today = DateTime.now();
    String todayDate = "${today.year}-${today.month}-${today.day}";

    int total = 0;
    int pending = 0;
    int completed = 0;
    int earnings = 0;

    // PENDING (from pendingBookings)
    for (var booking in pendingBookings) {
      if (booking.scheduledAt == null) continue;

      String d =
          "${booking.scheduledAt!.year}-${booking.scheduledAt!.month}-${booking.scheduledAt!.day}";

      if (d == todayDate) {
        pending++;
        total++;
      }
    }

    // COMPLETED (from historyBookings)
    for (var booking in historyBookings) {
      if (booking.scheduledAt == null) continue;

      String d =
          "${booking.scheduledAt!.year}-${booking.scheduledAt!.month}-${booking.scheduledAt!.day}";

      if (d == todayDate && booking.status == "COMPLETED") {
        completed++;
        total++;
        earnings += int.tryParse(booking.amount) ?? 0;
      }
    }

    // UPDATE UI
    todaysTotalJobs.value = total;
    todaysPending.value = pending;
    todaysCompleted.value = completed;
    todaysEarnings.value = earnings;
  }

  Future<void> loadEmployeeData() async {
    employeeName.value = await SharedPrefsHelper.getString("employeeName");
    designation.value =
        await SharedPrefsHelper.getString("employeeDesignation");
  }

  // ---------------------------------------
  // FETCH PENDING BOOKINGS
  // ---------------------------------------
  Future<void> fetchPendingBookings() async {
    try {
      isLoading(true);

      final response = await repository.getApiPendingBokkings();

      List data = response.data["bookings"];

      pendingBookings.assignAll(
        data.map((e) => BookingModel.fromJson(e)).toList(),
      );
    } catch (e) {
      errorToast("Failed to load pending bookings");
    } finally {
      isLoading(false);
    }
  }

  // ---------------------------------------
  // ACCEPT BOOKING
  // ---------------------------------------
  Future<void> acceptBooking(BookingModel booking) async {
    try {
      final empId = await SharedPrefsHelper.getString("employeeId");
      final empName = await SharedPrefsHelper.getString("employeeName");

      final body = {
        "booking_id": booking.id,
        "employee_id": empId,
        "employee_name": empName,
      };

      final response = await repository.postAcceptBooking(body);

      final newBooking = BookingModel.fromJson(response.data["booking"]);

      // remove from pending
      pendingBookings.removeWhere((b) => b.id == booking.id);

      // add into today's task
      todaysTasks.add(newBooking);
      calculateSummary();

      successToast("Booking assigned");
    } catch (e) {
      errorToast("Failed to accept booking");
    }
  }

  // ---------------------------------------
  // REJECT BOOKING
  // ---------------------------------------
  Future<void> rejectBooking(BookingModel booking) async {
    try {
      final empId = await SharedPrefsHelper.getString("employeeId");

      final body = {
        "booking_id": booking.id,
        "employee_id": empId,
      };

      await repository.postRejectBooking(body);

      pendingBookings.removeWhere((b) => b.id == booking.id);
      calculateSummary();
      successToast("Booking rejected");
    } catch (e) {
      errorToast("Failed to reject booking");
    }
  }

  // ---------------------------------------
  // HISTORY
  // ---------------------------------------
  List<HistoryBookingModel> get filteredHistory {
    if (searchText.value.isEmpty) return historyBookings;

    final q = searchText.value.toLowerCase();

    return historyBookings.where((b) {
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

      final data = Historymodel.fromJson(response.data);

      historyBookings.assignAll(data.bookings);
    } catch (e) {
      errorToast("Failed to load booking history");
    } finally {
      isLoading(false);
    }
  }

  //todasy Summary
  int get totalJobsToday {
    return todaysTasks.length;
  }

  int get pendingCount {
    return pendingBookings.length;
  }

  int get completedCount {
    return historyBookings.length;
  }

  String get earningsToday {
    int total = 0;

    for (var booking in historyBookings) {
      total += int.tryParse(booking.amount.toString()) ?? 0;
    }

    return total.toString();
  }
}
