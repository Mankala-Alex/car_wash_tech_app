import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/task_completed_controller.dart';

class TaskCompletedBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskCompletedController>(() => TaskCompletedController());
  }
}
