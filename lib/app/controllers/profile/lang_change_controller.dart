import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/shared_preferences.dart';

class LangChangeController extends GetxController {
  RxString selectedValue = "en".obs;

  @override
  void onInit() async {
    String? languageCode = await SharedPrefsHelper.getString(
      SharedPrefsHelper.languageCode,
    );

    if (languageCode.isNotEmpty) {
      selectedValue.value = languageCode;
    }

    super.onInit();
  }

  void applyLanguageChange() {
    if (selectedValue.value.isEmpty) return;

    if (selectedValue.value == 'en') {
      SharedPrefsHelper.setString(SharedPrefsHelper.languageCode, 'en');
      SharedPrefsHelper.setString(SharedPrefsHelper.countryCode, 'US');
      Get.updateLocale(const Locale('en', 'US'));
    } else if (selectedValue.value == 'ar') {
      SharedPrefsHelper.setString(SharedPrefsHelper.languageCode, 'ar');
      SharedPrefsHelper.setString(SharedPrefsHelper.countryCode, 'SA');
      Get.updateLocale(const Locale('ar', 'SA'));
    }

    Get.back();
  }
}
