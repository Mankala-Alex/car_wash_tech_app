import 'package:get/get.dart';
import 'package:car_wash_technician/app/controllers/washing_flow/payment_screen_controller.dart';

class PaymentScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentScreenController>(() => PaymentScreenController());
  }
}
