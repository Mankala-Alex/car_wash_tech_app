import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/cust_location_controller.dart';

class CustLocationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustLocationController>(() => CustLocationController());
  }
}
