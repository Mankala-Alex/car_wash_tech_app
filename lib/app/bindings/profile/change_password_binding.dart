import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/profile/change_password_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}
