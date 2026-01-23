import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/pre_task_checklist_controller.dart';

class PreTaskChecklistBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreTaskChecklistController>(() => PreTaskChecklistController());
  }
}
