import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/car_status_controller.dart';

class CarStatusBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarStatusController>(() => CarStatusController());
  }
}
