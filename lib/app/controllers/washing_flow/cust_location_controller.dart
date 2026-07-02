import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/helpers/shared_preferences.dart';
import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
import 'package:car_wash_technician/app/models/technician_model/booking_model.dart';
import 'package:car_wash_technician/app/repositories/bookings/bookings_repository.dart';
import 'package:car_wash_technician/app/routes/app_routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustLocationController extends GetxController {
  final BookingsRepository repository = BookingsRepository();

  late BookingModel booking; // <— SINGLE MODEL
  var isLoading = false.obs;

  GoogleMapController? mapController;

  final technicianLocation = Rxn<LatLng>();

  final customerLocation = Rxn<LatLng>();

  final markers = <Marker>{}.obs;

  @override
  void onInit() {
    booking = Get.arguments as BookingModel;

    if (booking.latitude != null && booking.longitude != null) {
      customerLocation.value = LatLng(
        booking.latitude!,
        booking.longitude!,
      );
    }

    getCurrentLocation();

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

  Future<void> openGoogleMapsNavigation() async {
    if (booking.latitude == null || booking.longitude == null) {
      errorToast("Customer location not available.");
      return;
    }

    final lat = booking.latitude!;
    final lng = booking.longitude!;

    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving",
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      errorToast("Unable to open Google Maps.");
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    technicianLocation.value = LatLng(
      position.latitude,
      position.longitude,
    );

    _createMarkers();
  }

  void _createMarkers() {
    markers.clear();

    if (technicianLocation.value != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("technician"),
          position: technicianLocation.value!,
          infoWindow: const InfoWindow(title: "You"),
        ),
      );
    }

    if (customerLocation.value != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("customer"),
          position: customerLocation.value!,
          infoWindow: InfoWindow(
            title: booking.customerName,
          ),
        ),
      );
    }

    markers.refresh();

    updateCamera();
  }

  void updateCamera() {
    if (mapController == null) return;

    if (technicianLocation.value == null || customerLocation.value == null) {
      return;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(
        technicianLocation.value!.latitude < customerLocation.value!.latitude
            ? technicianLocation.value!.latitude
            : customerLocation.value!.latitude,
        technicianLocation.value!.longitude < customerLocation.value!.longitude
            ? technicianLocation.value!.longitude
            : customerLocation.value!.longitude,
      ),
      northeast: LatLng(
        technicianLocation.value!.latitude > customerLocation.value!.latitude
            ? technicianLocation.value!.latitude
            : customerLocation.value!.latitude,
        technicianLocation.value!.longitude > customerLocation.value!.longitude
            ? technicianLocation.value!.longitude
            : customerLocation.value!.longitude,
      ),
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }
}
