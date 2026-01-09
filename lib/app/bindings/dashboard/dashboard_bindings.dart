import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/dashboard/dashboard_controller.dart';
import 'package:my_new_app/app/services/socket_service.dart';

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
