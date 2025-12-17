import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/task_completed_controller.dart';

class TaskCompletedBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskCompletedController>(() => TaskCompletedController());
  }
}
