import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/cust_location_controller.dart';
import 'package:car_wash_technician/app/theme/app_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CustLocationView extends GetView<CustLocationController> {
  CustLocationView({super.key});

  final GlobalKey<SlideActionState> slideKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 🚫 Completely disable back navigation

      child: Scaffold(
        backgroundColor: AppColors.bgLight,

        // -----------------------------
        // APP BAR
        // -----------------------------
        appBar: AppBar(
          backgroundColor: AppColors.bgLight,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "customer_location".tr,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),

        // -----------------------------
        // BODY
        // -----------------------------
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ---------------------------------
              // CUSTOMER CARD
              // ---------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person,
                          color: Colors.blue, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.booking.customerName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.booking.formattedAddress ??
                                controller.booking.address ??
                                "No Address",
                          ),
                          if (controller.booking.houseNumber != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "House No: ${controller.booking.houseNumber}",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          if (controller.booking.landmark != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Landmark: ${controller.booking.landmark}",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            controller.booking.serviceName,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Obx(
                () => Text(controller.distanceText.value),
              ),
              Obx(
                () => Text(controller.durationText.value),
              ),
              // ---------------------------------
              // MAP IMAGE
              // ---------------------------------
              Obx(
                () => SizedBox(
                  height: 320,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;

                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () => controller.updateCamera(),
                      );
                    },
                    initialCameraPosition: CameraPosition(
                      target: controller.customerLocation.value ??
                          const LatLng(17.4065, 78.4772),
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: controller.markers.value,
                    polylines: controller.polylines.value,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: false,
                    compassEnabled: true,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),

        // -----------------------------
        // BOTTOM BUTTONS
        // -----------------------------
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Navigate button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.navigation, color: Colors.white),
                  onPressed: controller.openGoogleMapsNavigation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  label: Text(
                    "navigate".tr,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------
              // SWIPE TO CONFIRM ARRIVAL
              // -------------------------------------------
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  height: 60,
                  child: SlideAction(
                    key: slideKey,
                    borderRadius: 16,
                    elevation: 0,
                    outerColor: AppColors.primaryLight,
                    innerColor: AppColors.secondaryLight,
                    text: "ive_arrived".tr,
                    textStyle: const TextStyle(
                      color: AppColors.bgBlackLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    sliderButtonIcon: const Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onSubmit: () async {
                      await controller.markArrived();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("arrived_confirmed".tr)),
                      );

                      await Future.delayed(const Duration(seconds: 1));

                      slideKey.currentState?.reset();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------
  // CARD DECORATION (WHITE + SHADOW)
  // ---------------------------------------
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.25),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
