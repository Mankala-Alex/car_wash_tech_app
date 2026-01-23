import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/all_tasks_controller.dart';

class AllTasksBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTasksController>(() => AllTasksController());
  }
}
