import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<CheckOutController>(CheckOutController(), permanent: true);
  }
}
