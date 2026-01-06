import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/models/technician_model/booking_model.dart';
import 'package:my_new_app/app/repositories/auth/auth_repository.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/models/bookings/history_model.dart';
import 'package:my_new_app/app/routes/app_routes.dart';

class DashboardController extends GetxController {
  final BookingsRepository repository = BookingsRepository();
  final AuthRepository authRepo = AuthRepository();

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
    super.onInit();
    loadEmployeeData();
    initData();
  }

  Future<void> initData() async {
    await fetchPendingBookings(); // wait for API 1
    await fetchBookingHistory(); // wait for API 2
    calculateSummary(); // now calculate correctly
  }

  bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void calculateSummary() {
    int pending = 0;
    int accepted = 0;
    int completed = 0;
    int earnings = 0;

    /// PENDING TODAY (created today)
    for (var booking in pendingBookings) {
      if (isToday(booking.createdAt)) {
        pending++;
      }
    }

    /// ACCEPTED TODAY (status became ASSIGNED today)
    for (var booking in historyBookings) {
      if (booking.status == "ASSIGNED" && isToday(booking.updatedAt)) {
        accepted++;
      }
    }

    /// COMPLETED TODAY + EARNINGS
    for (var booking in historyBookings) {
      if (booking.status == "COMPLETED" && isToday(booking.updatedAt)) {
        completed++;
        earnings += int.tryParse(booking.amount) ?? 0;
      }
    }

    todaysPending.value = pending;
    todaysCompleted.value = completed;
    todaysEarnings.value = earnings;
    todaysTotalJobs.value = pending + accepted + completed;
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

  Future<void> logout() async {
    try {
      // 1️⃣ Call logout API (best effort)
      await authRepo.logoutTechnician();
    } catch (e) {
      print("Logout API error: $e");
    } finally {
      // 2️⃣ Clear local storage
      await SharedPrefsHelper.clearAll();

      // 3️⃣ Reset GetX
      Get.deleteAll(force: true);

      // 4️⃣ Go to login
      Get.offAllNamed(Routes.login);
    }
  }
}
