import 'dart:async';

import 'package:get/get.dart';
import 'package:my_new_app/app/helpers/secure_store.dart';
import 'package:my_new_app/app/helpers/shared_preferences.dart';
import 'package:my_new_app/app/helpers/flutter_toast.dart';
import 'package:my_new_app/app/models/technician_model/booking_model.dart';
import 'package:my_new_app/app/repositories/auth/auth_repository.dart';
import 'package:my_new_app/app/repositories/bookings/bookings_repository.dart';
import 'package:my_new_app/app/models/bookings/history_model.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/services/socket_service.dart';

class DashboardController extends GetxController {
  final BookingsRepository repository = BookingsRepository();
  final AuthRepository authRepo = AuthRepository();
  final SocketService socketService = Get.find<SocketService>();
////////////////////
  ///demo purpose just for auto refresh
  Timer? _refreshTimer;
////////////////////
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
    _setupSocketListeners();

    // 👇 DEMO ONLY
    _startAutoRefresh();
  }

////////////////////////////////////////////////
  ///demo purpose just for auto refresh
  void _startAutoRefresh() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5), // demo friendly
      (_) {
        print("🔄 AUTO REFRESH TICK");
        fetchPendingBookings();
      },
    );
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

//////////////////////////////////////////
  /// Setup real-time socket event listeners
  void _setupSocketListeners() {
    try {
      // Listen to new booking created
      socketService.bookingCreatedEvent.listen((bookingData) {
        if (bookingData != null) {
          _handleBookingCreated(bookingData);
        }
      });

      // Listen to booking accepted
      socketService.bookingAcceptedEvent.listen((bookingData) {
        if (bookingData != null) {
          _handleBookingStatusChange(bookingData, "ASSIGNED");
        }
      });

      // Listen to booking arrived
      socketService.bookingArrivedEvent.listen((bookingData) {
        if (bookingData != null) {
          _handleBookingStatusChange(bookingData, "ARRIVED");
        }
      });

      // Listen to booking started
      socketService.bookingStartedEvent.listen((bookingData) {
        if (bookingData != null) {
          _handleBookingStatusChange(bookingData, "IN_PROGRESS");
        }
      });

      // Listen to booking completed
      socketService.bookingCompletedEvent.listen((bookingData) {
        if (bookingData != null) {
          _handleBookingStatusChange(bookingData, "COMPLETED");
        }
      });
    } catch (e) {
      print("Socket listeners setup error: $e");
    }
  }

  /// Handle new booking created event
  void _handleBookingCreated(Map<String, dynamic> bookingData) {
    try {
      final raw = bookingData['booking'] ?? bookingData;
      final booking = BookingModel.fromJson(raw);

      if (!pendingBookings.any((b) => b.id == booking.id)) {
        pendingBookings.insert(0, booking);
        calculateSummary();
      }
    } catch (e) {
      print("booking_created parse error: $e");
    }
  }

  /// Handle booking status change event
  void _handleBookingStatusChange(
      Map<String, dynamic> bookingData, String expectedStatus) {
    try {
      final raw = bookingData['booking'] ?? bookingData;
      final bookingId = raw['id'];

      if (bookingId == null) return;

      // Remove from pending
      pendingBookings.removeWhere((b) => b.id == bookingId);

      final index = todaysTasks.indexWhere((b) => b.id == bookingId);

      if (index != -1) {
        // ✅ UPDATE STATUS WITHOUT copyWith
        final updated = BookingModel.fromJson({
          ...raw,
          'status': expectedStatus,
        });

        todaysTasks[index] = updated;
      } else if (expectedStatus == "ASSIGNED") {
        final booking = BookingModel.fromJson(raw);
        todaysTasks.insert(0, booking);
      }

      calculateSummary();
    } catch (e) {
      print("Error handling status change event: $e");
    }
  }

  Future<void> initData() async {
    isLoading(true);
    try {
      // Run both API calls in parallel
      await Future.wait([
        fetchPendingBookings(),
        fetchBookingHistory(),
      ]);

      // Populate today's tasks from assigned bookings
      populateTodaysTasks();
      calculateSummary();
    } finally {
      isLoading(false);
    }
  }

  void populateTodaysTasks() {
    // Get today's assigned bookings from history
    final assignedToday = historyBookings
        .where((b) => b.status == "ASSIGNED" && isToday(b.updatedAt))
        .toList();
    todaysTasks.assignAll(
      assignedToday
          .map((h) => BookingModel(
                id: h.id,
                bookingCode: h.bookingCode,
                customerId: h.customerId,
                customerName: h.customerName,
                vehicle: h.vehicle,
                serviceId: h.serviceId,
                serviceName: h.serviceName,
                scheduledAt: h.scheduledAt,
                washerId: h.washerId,
                washerName: h.washerName,
                status: h.status,
                amount: h.amount,
                createdAt: h.createdAt,
                updatedAt: h.updatedAt,
                slotId: h.slotId,
                beforeImages: h.beforeImages,
                afterImages: h.afterImages,
              ))
          .toList(),
    );
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
      final response = await repository.getApiPendingBokkings();

      List data = response.data["bookings"];

      pendingBookings.assignAll(
        data.map((e) => BookingModel.fromJson(e)).toList(),
      );
    } catch (e) {
      print("Error fetching pending bookings: $e");
      errorToast("Failed to load pending bookings");
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

      if (employeeId.isEmpty) {
        errorToast("Employee ID not found");
        return;
      }

      final response = await repository.getApiBookingHistory(
        query: {"employee_id": employeeId},
      );

      final data = Historymodel.fromJson(response.data);

      historyBookings.assignAll(data.bookings);
    } catch (e) {
      print("Error fetching booking history: $e");
      errorToast("Failed to load booking history");
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
      // Disconnect socket before logout
      socketService.disconnect();

      await authRepo.logoutTechnician();
    } catch (e) {
      print("Logout API error: $e");
    } finally {
      await SharedPrefsHelper.clearAll();

      await FlutterSecureStore().storeSingleValue(
        SharedPrefsHelper.accessToken,
        "",
      );

      Get.deleteAll(force: true);
      Get.offAllNamed(Routes.login);
    }
  }
}
