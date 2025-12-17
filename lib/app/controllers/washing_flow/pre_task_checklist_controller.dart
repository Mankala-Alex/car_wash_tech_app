import 'package:get/get.dart';

class PreTaskChecklistController extends GetxController{
   var items = <Map<String, dynamic>>[
    {
      "name": "Pressure Washer",
      "checked": false.obs,
      "missing": false.obs,
      "note": "",
    },
    {
      "name": "Foam Cannon",
      "checked": false.obs,
      "missing": false.obs,
      "note": "",
    },
    {
      "name": "Vacuum Cleaner",
      "checked": false.obs,
      "missing": false.obs,
      "note": "",
    },
    {
      "name": "Microfiber Towels (x5)",
      "checked": true.obs,
      "missing": true.obs,
      "note": "Only 3 available.",
    },
    {
      "name": "Detailing Brushes",
      "checked": false.obs,
      "missing": false.obs,
      "note": "",
    },
  ].obs;

  var selectedMissingItem = "".obs;
  var reportText = "".obs;

  void markAsMissing(String name) {
    selectedMissingItem.value = name;
  }

  void confirmMissing() {
    if (selectedMissingItem.isNotEmpty) {
      int index = items.indexWhere((e) => e["name"] == selectedMissingItem.value);
      if (index != -1) {
        items[index]["missing"].value = true;
        items[index]["note"] = reportText.value;
      }
    }
    selectedMissingItem.value = "";
    reportText.value = "";
  }

  void cancelMissing() {
    selectedMissingItem.value = "";
    reportText.value = "";
  }
}