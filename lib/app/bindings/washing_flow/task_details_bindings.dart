import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/task_details_controller.dart';

class TaskDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskDetailsController>(() => TaskDetailsController());
  }
}
