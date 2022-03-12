import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/auth/login.dart';
import 'package:fluttergistshop/services/api_calls.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rxn<UserModel> usermodel = Rxn<UserModel>();

  var isLoading = true.obs;
  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  Future getUserData() async {
    try {
      isLoading(true);
      UserModel user = await ApiCalls.getUserById();

      if (user != null) {
        usermodel.value = user;
      } else {
        Get.to(() => Login());
      }
    } finally {
      isLoading(false);
    }
  }
}
