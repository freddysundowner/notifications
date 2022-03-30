import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/controllers/global.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put<ShopController>(ShopController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<CheckOutController>(CheckOutController(), permanent: true);
    Get.put<GlobalController>(GlobalController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}
