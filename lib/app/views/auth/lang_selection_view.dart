import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_new_app/app/theme/app_theme.dart';
import '../../controllers/auth/lang_selection_controller.dart';

class LangSelectionView extends GetView<LangSelectionController> {
  const LangSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
      
            // ============================
            // TOP ICON
            // ============================
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child:  const Icon(
                Icons.local_car_wash_rounded,
                color: AppColors.primaryLight,
                size: 40,
              ),
            ),
      
            const SizedBox(height: 25),
      
            // ============================
            // TITLE
            // ============================
            const Text(
              "Select Language",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
      
            const SizedBox(height: 10),
      
            // SUBTITLE
            const Text(
              "Please choose your preferred language to continue\nusing the technician app.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                height: 1.4,
              ),
            ),
      
            const SizedBox(height: 35),
      
            // ============================
            // ENGLISH OPTION
            // ============================
            Obx(() {
              bool active = controller.selectedValue.value == 'en';
      
              return GestureDetector(
                onTap: () => controller.selectedValue.value = 'en',
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: active ? AppColors.primaryLight : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      
      
                      const SizedBox(width: 15),
      
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "English",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "English",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
      
                      Icon(
                        active
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: active ? AppColors.secondaryLight : Colors.grey.shade400,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              );
            }),
      
            const SizedBox(height: 15),
      
            // ============================
            // ARABIC OPTION
            // ============================
            Obx(() {
              bool active = controller.selectedValue.value == 'ar';
      
              return GestureDetector(
                onTap: () => controller.selectedValue.value = 'ar',
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: active ? AppColors.primaryLight : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      
      
                      const SizedBox(width: 15),
      
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "العربية",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Arabic",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
      
                      Icon(
                        active
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: active ? AppColors.secondaryLight : Colors.grey.shade400,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              );
            }),
      
            const Spacer(),
      
            // ============================
            // CONTINUE BUTTON
            // ============================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.changeLanguage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
      
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


// // my_new_app/lib/app/views/lang_selection_view.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/auth/lang_selection_controller.dart';

// class LangSelectionView extends GetView<LangSelectionController> {
//   const LangSelectionView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('select_language'.tr)),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 controller.selectedValue.value = 'en';
//                 controller.changeLanguage();
//               },
//               child: Text('english'.tr),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 controller.selectedValue.value = 'ar';
//                 controller.changeLanguage();
//               },
//               child: Text('arabic'.tr),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
