import 'package:car_wash_technician/app/custome_widgets/skeleton_box.dart';
import 'package:car_wash_technician/app/helpers/flutter_toast.dart';
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
      //canPop: false, // 🚫 Completely disable back navigation

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "SERVICE",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            controller.booking.customerName,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Icon(
                                Icons.local_car_wash,
                                color: AppColors.textDefaultLight,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.booking.serviceName,
                                  style: const TextStyle(
                                    color: AppColors.textDefaultLight,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "In Transit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.secondaryLight,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Destination Address",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.booking.formattedAddress ??
                                controller.booking.address ??
                                "No Address",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "House No",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.booking.houseNumber ?? "--",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Landmark",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.booking.landmark ?? "--",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: SizedBox(
                        height: 350,
                        width: double.infinity,
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
                          compassEnabled: true,
                          mapToolbarEnabled: false,
                        ),
                      ),
                    ),

                    // Route info
                    if (!controller.isRouteLoading.value)
                      Positioned(
                        top: 15,
                        left: 15,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.route, color: Colors.blue),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  controller.distanceText.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  controller.durationText.value,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Skeleton Loader
                    if (controller.isRouteLoading.value)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Center(
                            child: SkeletonBox(
                              width: 450,
                              height: 450,
                              radius: 22,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Stack(
              //   children: [
              //     ClipRRect(
              //       borderRadius: BorderRadius.circular(22),
              //       child: SizedBox(
              //         height: 350,
              //         width: double.infinity,
              //         child: Obx(
              //           () => GoogleMap(
              //             onMapCreated: (GoogleMapController mapController) {
              //               controller.mapController = mapController;

              //               Future.delayed(
              //                 const Duration(milliseconds: 500),
              //                 () => controller.updateCamera(),
              //               );
              //             },
              //             initialCameraPosition: CameraPosition(
              //               target: controller.customerLocation.value ??
              //                   const LatLng(17.4065, 78.4772),
              //               zoom: 15,
              //             ),
              //             myLocationEnabled: true,
              //             myLocationButtonEnabled: true,
              //             markers: controller.markers.value,
              //             polylines: controller.polylines.value,
              //             zoomControlsEnabled: true,
              //             compassEnabled: true,
              //             mapToolbarEnabled: false,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Positioned(
              //       top: 15,
              //       left: 15,
              //       right: 15,
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 18,
              //           vertical: 14,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(16),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black.withOpacity(.08),
              //               blurRadius: 12,
              //             ),
              //           ],
              //         ),
              //         child: Obx(
              //           () => Row(
              //             children: [
              //               const Icon(
              //                 Icons.route,
              //                 color: Colors.blue,
              //               ),
              //               const SizedBox(width: 10),
              //               Expanded(
              //                 child: Text(
              //                   controller.distanceText.value,
              //                   style: const TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 18,
              //                   ),
              //                 ),
              //               ),
              //               Container(
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 12,
              //                   vertical: 8,
              //                 ),
              //                 decoration: BoxDecoration(
              //                   color: Colors.orange.shade100,
              //                   borderRadius: BorderRadius.circular(25),
              //                 ),
              //                 child: Text(
              //                   controller.durationText.value,
              //                   style: const TextStyle(
              //                     color: Colors.orange,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 25),
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
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

                      ScaffoldMessenger.of(context)
                          .showSnackBar(successToast("arrived_confirmed".tr));

                      await Future.delayed(const Duration(seconds: 1));

                      slideKey.currentState?.reset();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // body: SingleChildScrollView(
        //   padding: const EdgeInsets.all(16),
        //   child: Column(
        //     children: [
        //       // ---------------------------------
        //       // CUSTOMER CARD
        //       // ---------------------------------
        //       Container(
        //         width: double.infinity,
        //         padding: const EdgeInsets.all(16),
        //         decoration: _cardDecoration(),
        //         child: Row(
        //           children: [
        //             Container(
        //               padding: const EdgeInsets.all(12),
        //               decoration: BoxDecoration(
        //                 color: Colors.blue.withOpacity(0.15),
        //                 shape: BoxShape.circle,
        //               ),
        //               child: const Icon(Icons.person,
        //                   color: Colors.blue, size: 24),
        //             ),
        //             const SizedBox(width: 14),
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     controller.booking.customerName,
        //                     style: const TextStyle(
        //                       fontSize: 17,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   const SizedBox(height: 4),
        //                   Text(
        //                     controller.booking.formattedAddress ??
        //                         controller.booking.address ??
        //                         "No Address",
        //                   ),
        //                   if (controller.booking.houseNumber != null)
        //                     Padding(
        //                       padding: const EdgeInsets.only(top: 5),
        //                       child: Text(
        //                         "House No: ${controller.booking.houseNumber}",
        //                         style: const TextStyle(fontSize: 13),
        //                       ),
        //                     ),
        //                   if (controller.booking.landmark != null)
        //                     Padding(
        //                       padding: const EdgeInsets.only(top: 4),
        //                       child: Text(
        //                         "Landmark: ${controller.booking.landmark}",
        //                         style: const TextStyle(fontSize: 13),
        //                       ),
        //                     ),
        //                   const SizedBox(height: 6),
        //                   Text(
        //                     controller.booking.serviceName,
        //                     style: const TextStyle(
        //                       color: Colors.blue,
        //                       fontSize: 15,
        //                       fontWeight: FontWeight.w600,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ],
        //         ),
        //       ),

        //       const SizedBox(height: 20),
        //       Obx(
        //         () => Text(controller.distanceText.value),
        //       ),
        //       Obx(
        //         () => Text(controller.durationText.value),
        //       ),
        //       // ---------------------------------
        //       // MAP IMAGE
        //       // ---------------------------------
        //       Obx(
        //         () => SizedBox(
        //           height: 320,
        //           child: GoogleMap(
        //             onMapCreated: (GoogleMapController mapController) {
        //               controller.mapController = mapController;

        //               Future.delayed(
        //                 const Duration(milliseconds: 500),
        //                 () => controller.updateCamera(),
        //               );
        //             },
        //             initialCameraPosition: CameraPosition(
        //               target: controller.customerLocation.value ??
        //                   const LatLng(17.4065, 78.4772),
        //               zoom: 15,
        //             ),
        //             myLocationEnabled: true,
        //             myLocationButtonEnabled: true,
        //             markers: controller.markers.value,
        //             polylines: controller.polylines.value,
        //             zoomControlsEnabled: true,
        //             mapToolbarEnabled: false,
        //             compassEnabled: true,
        //           ),
        //         ),
        //       ),

        //       const SizedBox(height: 30),
        //     ],
        //   ),
        // ),

        // -----------------------------
        // BOTTOM BUTTONS
        // -----------------------------
      ),
    );
  }
}
