import 'package:get/get.dart';

class PaymentScreenController extends GetxController {
  var isPaid = false.obs;

  void markPaid() {
    isPaid.value = true;
  }
}
