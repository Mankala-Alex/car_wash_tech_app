import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/dashboard/dashboard_controller.dart';
import 'package:car_wash_technician/app/services/socket_service.dart';

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
