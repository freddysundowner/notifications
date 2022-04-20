import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import 'auth_controller.dart';

class UserController extends GetxController {
  var currentProfile = UserModel().obs;
  var profileLoading = false.obs;
  var ordersLoading = false.obs;
  var userOrders = [].obs;
  var shopOrders = [].obs;
  var userFollowersFollowing = [].obs;
  var gettingFollowers = false.obs;
  var gettingAddress = false.obs;
  var myAddresses = [].obs;
  var userOrdersPageNumber = 1.obs;
  var loadingMoreUserOrders = false.obs;
  final userOrdersScrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();

    orderScrollControllerListener();

  }

  void orderScrollControllerListener() {

    userOrdersScrollController.addListener(() {
      if (userOrdersScrollController.position.atEdge) {
        bool isTop = userOrdersScrollController.position.pixels == 0;
        if (isTop) {
          printOut('At the top');
        } else {
          userOrdersPageNumber.value = userOrdersPageNumber.value + 1;
          getMoreUserOrders();
        }
      }
    });
  }

  getUserProfile(String userId) async {
    Get.find<ProductController>().products.clear();
    try {
      profileLoading.value = true;
      var user = await UserAPI().getUserProfile(userId);
      print("found ------- ${user}");

      if (user == null) {
        currentProfile.value = UserModel();
      } else {
        currentProfile.value = UserModel.fromJson(user);
      }

      profileLoading.value = false;

      if (currentProfile.value.shopId != null) {
        await ProductController.getProductsByShop(
            currentProfile.value.shopId!.id!);
      }
    } catch (e, s) {
      profileLoading.value = false;
      printOut("Error getting user $userId profile $e $s");
    }
  }

  getUserOrders() async {
    try {
      ordersLoading.value = true;
      var orders =
          await UserAPI().getUserOrders(FirebaseAuth.instance.currentUser!.uid);

      if (orders == null) {
        userOrders.value = [];
      } else {
        userOrders.value = orders;
      }

      ordersLoading.value = false;
    } catch (e, s) {
      ordersLoading.value = false;
      printOut("Error getting user orders $e $s");
    }
  }

  getMoreUserOrders() async {
    try {
      loadingMoreUserOrders.value = true;
      var orders =
      await UserAPI().getUserOrders(FirebaseAuth.instance.currentUser!.uid);

      if (orders != null) {
        userOrders.addAll(orders);
      }

      loadingMoreUserOrders.value = false;
    } catch (e, s) {
      loadingMoreUserOrders.value = false;
      printOut("Error getting user orders $e $s");
    }
  }

  getShopOrders() async {
    try {
      ordersLoading.value = true;
      var orders = await UserAPI().getShopOrders(
          Get.find<AuthController>().usermodel.value!.shopId!.id!);

      if (orders == null) {
        shopOrders.value = [];
      } else {
        shopOrders.value = orders;
      }

      ordersLoading.value = false;
    } catch (e, s) {
      ordersLoading.value = false;
      printOut("Error getting user orders $e $s");
    }
  }

  gettingMyAddrresses() async {
    try {
      gettingAddress.value = true;
      var address = await UserAPI.getAddressesFromUserId();

      if (address == null) {
        myAddresses.value = [];
      } else {
        myAddresses.value = address;
      }

      gettingAddress.value = false;
    } catch (e, s) {
      gettingAddress.value = false;
      printOut("Error getting user orders $e $s");
    }
  }

  getUserFollowers(String uid) async {
    try {
      gettingFollowers.value = true;

      userFollowersFollowing.value = [];

      var users = await UserAPI().getUserFollowers(uid);

      if (users == null) {
        userFollowersFollowing.value = [];
      } else {
        userFollowersFollowing.value = users;
      }

      gettingFollowers.value = false;
    } catch (e, s) {
      gettingFollowers.value = false;
      printOut("Error getting user followers $e $s");
    }
  }

  getUserFollowing(String uid) async {
    try {
      gettingFollowers.value = true;

      userFollowersFollowing.value = [];

      var users = await UserAPI().getUserFollowing(uid);

      if (users == null) {
        userFollowersFollowing.value = [];
      } else {
        userFollowersFollowing.value = users;
      }

      gettingFollowers.value = false;
    } catch (e, s) {
      gettingFollowers.value = false;
      printOut("Error getting user following $e $s");
    }
  }

  upgradeAccount() async {
    try {
      await UserAPI().upgradeAUser();
      currentProfile.value.memberShip = 1;
      currentProfile.value.wallet =
          currentProfile.value.wallet! - PREMIUM_UPGRADE_COINS_AMOUNT;
      currentProfile.refresh();
      Get.snackbar(
        "",
        "You have successfully upgraded your account o premium membership, Enjoy Gisting",
          backgroundColor: sc_snackBar,
          colorText: Colors.white
      );
    } catch (e, s) {
      printOut("Error upgrading account $e $s");
      Get.snackbar(
        "",
        "An error occured while upgrading your account. Try again later",
          backgroundColor: sc_snackBar,
          colorText: Colors.white
      );
    }
  }
}
