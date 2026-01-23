import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/car_status_controller.dart';

class CarStatusBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarStatusController>(() => CarStatusController());
  }
}
