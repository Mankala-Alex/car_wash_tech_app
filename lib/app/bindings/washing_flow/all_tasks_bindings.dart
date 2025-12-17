import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/all_tasks_controller.dart';

class AllTasksBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTasksController>(() => AllTasksController());
  }
}
