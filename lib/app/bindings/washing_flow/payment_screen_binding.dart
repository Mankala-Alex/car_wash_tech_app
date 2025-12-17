import 'package:get/get.dart';
import 'package:my_new_app/app/controllers/washing_flow/payment_screen_controller.dart';

class PaymentScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentScreenController>(() => PaymentScreenController());
  }
}
