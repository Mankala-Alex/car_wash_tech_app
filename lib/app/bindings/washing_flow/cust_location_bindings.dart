import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/cust_location_controller.dart';

class CustLocationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustLocationController>(() => CustLocationController());
  }
}
