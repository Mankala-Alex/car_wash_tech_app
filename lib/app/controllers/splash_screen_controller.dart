import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../helpers/secure_store.dart';
import '../helpers/shared_preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("[SPLASH] ✓ onInit called");
  }

  @override
  void onReady() {
    super.onReady();
    print("[SPLASH] ✓ onReady called - starting navigation");
    Future.delayed(const Duration(seconds: 2), () async {
      await checkTokenAndNavigate();
    });
  }

  Future<void> checkTokenAndNavigate() async {
    print("[SPLASH] Checking for existing token...");

    // Wait 2 seconds before checking
    await Future.delayed(const Duration(seconds: 2));

    try {
      final token = await FlutterSecureStore()
          .getSingleValue(SharedPrefsHelper.accessToken);

      print(
          "[SPLASH] Token result: ${token?.isEmpty ?? true ? 'EMPTY' : 'EXISTS'}");

      if (token != null && token.isNotEmpty) {
        print("[SPLASH] ✓ Token found - navigating to Dashboard");
        Get.offAllNamed(Routes.dashboard);
      } else {
        print("[SPLASH] ✗ No token - navigating to Language Selection");
        Get.offAllNamed(Routes.langeSelection);
      }
    } catch (e) {
      print(
          "[SPLASH] ✗ Error checking token: $e - going to Language Selection");
      Get.offAllNamed(Routes.langeSelection);
    }
  }
}
