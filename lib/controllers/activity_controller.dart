import 'package:fluttergistshop/services/activities_api.dart';
import 'package:fluttergistshop/utils/Functions.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'auth_controller.dart';

class ActivityController extends GetxController {
  var allActivitiesLoading = false.obs;
  var allActivities = [].obs;


  @override
  void onInit() {
    super.onInit();
    getUserActivities();
  }

  getUserActivities() async {
    try {
      allActivitiesLoading.value = true;

      var activities = await ActivitiesAPI().getAllUserActivities(
          Get.find<AuthController>().usermodel.value!.id!);
      if (activities != null) {

        allActivities.value = activities;

      } else {
        allActivities.value = [];
      }

      allActivities.refresh();
      allActivitiesLoading.value = false;

    } catch (e) {
      allActivitiesLoading.value = false;
      allActivities.value = [];
      printOut("Error getting activities $e");
    }
  }
}
