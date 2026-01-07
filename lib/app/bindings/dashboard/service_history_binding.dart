import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/dashboard/service_history_controller.dart';

class ServiceHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceHistoryController>(() => ServiceHistoryController());
  }
}
