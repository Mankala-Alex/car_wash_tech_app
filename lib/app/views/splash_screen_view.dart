// my_new_app/lib/app/views/splash_screen_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';
import '../theme/app_theme.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = CustomTheme.of(context);

    // Trigger navigation after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("[SPLASH VIEW] Build complete - triggering navigation check");
      controller.checkTokenAndNavigate();
    });

    return Scaffold(
        backgroundColor: customTheme.bgColor,
        body: const Center(
          child: Text("splash screen"),
        ));
  }
}
