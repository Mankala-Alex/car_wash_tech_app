import 'package:car_wash_technician/app/controllers/dashboard/dashboard_controller.dart';
import 'package:car_wash_technician/app/services/socket_service.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SocketService>()) {
      final socketService = Get.put<SocketService>(SocketService());
      socketService.connect(); // ✅ THIS WAS MISSING
    }

    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
