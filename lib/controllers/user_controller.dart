
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class UserController extends GetxController {

  var currentProfile = UserModel().obs;
  var profileLoading = false.obs;

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

      printOut("Error getting user $userId profile $e $s");
    }
  }

}