import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/pre_task_checklist_controller.dart';

class PreTaskChecklistBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreTaskChecklistController>(() => PreTaskChecklistController());
  }
}
