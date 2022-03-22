
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class UserController extends GetxController {

  var currentProfile = UserModel().obs;
  var profileLoading = false.obs;
  var ordersLoading = false.obs;
  var userOrders = [].obs;

  getUserProfile(String userId) async {

    try {
      profileLoading.value = true;
      var user = await UserAPI().getUserProfile(userId);

      if (user == null) {
        currentProfile.value = UserModel();
      } else {
        currentProfile.value = UserModel.fromJson(user);
      }

      profileLoading.value = false;
    } catch(e, s) {
      profileLoading.value = false;
      printOut("Error getting user $userId profile $e $s");
    }
  }

  getUserOrders() async {
    try {
      ordersLoading.value = true;
      var orders = await UserAPI().getUserOrders(FirebaseAuth.instance.currentUser!.uid);

      if (orders == null) {
        userOrders.value = [];
      } else {
        userOrders.value = orders;
      }

      ordersLoading.value = false;
    } catch(e, s) {
      ordersLoading.value = false;
      printOut("Error getting user orders $e $s");
    }
  }

}