import 'package:flutter/widgets.dart';
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

  final isRouteLoading = true.obs;

  final technicianLocation = Rxn<LatLng>();

  final customerLocation = Rxn<LatLng>();

  final markers = <Marker>{}.obs;

  final polylines = <Polyline>{}.obs;

  final distanceText = "".obs;

  final durationText = "".obs;

  BitmapDescriptor? homeMarker;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    booking = Get.arguments as BookingModel;

    if (booking.latitude != null && booking.longitude != null) {
      customerLocation.value = LatLng(
        booking.latitude!,
        booking.longitude!,
      );
    }

    await loadMarkers();

    await getCurrentLocation();
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
    // technicianLocation.value = const LatLng(
    //   24.71420,
    //   46.67610,
    // );

    _createMarkers();

    await getNavigationRoute();
  }

  Future<void> getNavigationRoute() async {
    isRouteLoading.value = true;
    try {
      if (technicianLocation.value == null || customerLocation.value == null) {
        return;
      }

      final body = {
        "originLatitude": technicianLocation.value!.latitude,
        "originLongitude": technicianLocation.value!.longitude,
        "destinationLatitude": customerLocation.value!.latitude,
        "destinationLongitude": customerLocation.value!.longitude,
      };

      final response = await repository.postNavigationRoute(body);

      final data = response.data["data"];

      distanceText.value =
          "${(data["distanceMeters"] / 1000).toStringAsFixed(1)} km";

      final seconds =
          int.parse(data["duration"].toString().replaceAll("s", ""));

      durationText.value = "${(seconds / 60).round()} mins";

      _drawPolyline(data["coordinates"]);

      isRouteLoading.value = false;
    } catch (e) {
      isRouteLoading.value = false;
      print(e);
    }
  }

  void _drawPolyline(List coordinates) {
    polylines.clear();

    final points = coordinates.map<LatLng>((e) {
      return LatLng(
        e[1].toDouble(),
        e[0].toDouble(),
      );
    }).toList();

    polylines.add(
      Polyline(
        polylineId: const PolylineId("route"),
        points: points,
        width: 6,
        color: const Color(0xFF1976D2),
      ),
    );

    polylines.refresh();
    updateCameraToRoute(points);
  }

  void updateCameraToRoute(List<LatLng> points) {
    if (mapController == null || points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80,
      ),
    );
  }

  void _createMarkers() {
    markers.clear();

    // Technician marker
    // if (technicianLocation.value != null) {
    //   markers.add(
    //     Marker(
    //       markerId: const MarkerId("technician"),
    //       position: technicianLocation.value!,
    //       infoWindow: const InfoWindow(title: "Your Location"),
    //       icon: BitmapDescriptor.defaultMarkerWithHue(
    //         BitmapDescriptor.hueAzure,
    //       ),
    //     ),
    //   );
    // }

    // Customer marker (Home)
    if (customerLocation.value != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("customer"),
          position: customerLocation.value!,
          icon: homeMarker ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: booking.customerName,
          ),
        ),
      );
    }

    markers.refresh();

    updateCamera();
  }
  // void _createMarkers() {
  //   markers.clear();

  //   if (technicianLocation.value != null) {
  //     markers.add(
  //       Marker(
  //         markerId: const MarkerId("technician"),
  //         position: technicianLocation.value!,
  //         infoWindow: const InfoWindow(title: "You"),
  //       ),
  //     );
  //   }

  //   if (customerLocation.value != null) {
  //     markers.add(
  //       Marker(
  //         markerId: const MarkerId("customer"),
  //         position: customerLocation.value!,
  //         infoWindow: InfoWindow(
  //           title: booking.customerName,
  //         ),
  //       ),
  //     );
  //   }

  //   markers.refresh();

  //   updateCamera();
  // }

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

  Future<void> loadMarkers() async {
    homeMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/3d-house.png",
    );
  }
}
