import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/cust_location_controller.dart';
import 'package:my_new_app/app/routes/app_routes.dart';
import 'package:my_new_app/app/theme/app_theme.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CustLocationView extends GetView<CustLocationController> {
  CustLocationView({super.key});

  final GlobalKey<SlideActionState> slideKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,

      // -----------------------------
      // APP BAR
      // -----------------------------
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        title: const Text(
          "Job Location",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
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
                    child:
                        const Icon(Icons.person, color: Colors.blue, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "John Appleseed",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "123 Main Street, Anytown, CA 91234",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Premium Exterior Wash",
                          style: TextStyle(
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

            // ---------------------------------
            // MAP IMAGE
            // ---------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/car_tech/map.png",
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                label: const Text(
                  "Navigate",
                  style: TextStyle(
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
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                height: 60,
                child: SlideAction(
                  key: slideKey,
                  borderRadius: 16,
                  elevation: 0,
                  outerColor: AppColors.primaryLight,
                  innerColor: AppColors.secondaryLight,
                  text: "I've Arrived",
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
                    // Your arrival logic here
                    // Example:
                    // await controller.markArrived();
                    Get.toNamed(Routes.preTaskChecklist);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Arrived confirmed")),
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
