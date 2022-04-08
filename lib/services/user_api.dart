import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/controllers/favorite_controller.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

import 'client.dart';
import 'end_points.dart';
import 'notification_api.dart';

// api //
class UserAPI {
  getAllUsers() async {
    var users =
        await DbBase().databaseRequest(allUsers, DbBase().getRequestType);

    return jsonDecode(users);
  }

  getUserProfile(String uid) async {
    var user =
        await DbBase().databaseRequest(userById + uid, DbBase().getRequestType);

    if (user == null) {
      return null;
    } else {
      return jsonDecode(user);
    }
  }

  getUserFollowers(String uid) async {
    var users = await DbBase()
        .databaseRequest(userFollowers + uid, DbBase().getRequestType);

    if (users == null) {
      return null;
    } else {
      return jsonDecode(users);
    }
  }

  getUserFollowing(String uid) async {
    var users = await DbBase()
        .databaseRequest(userFollowing + uid, DbBase().getRequestType);

    if (users == null) {
      return null;
    } else {
      return jsonDecode(users);
    }
  }

  searchUser(String text) async {
    var users = await DbBase().databaseRequest(
        searchUsersByFirstName + text, DbBase().getRequestType);

    return jsonDecode(users);
  }

  getUserOrders(String uid) async {
    var orders = await DbBase()
        .databaseRequest(userOrders + uid, DbBase().getRequestType);

    return jsonDecode(orders);
  }

  getShopOrders(String id) async {
    var orders = await DbBase()
        .databaseRequest(shopOrders + id, DbBase().getRequestType);

    return jsonDecode(orders);
  }

  updateUser(Map<String, dynamic> body, String id) async {
    try {
      printOut("updating user $body");

      var updated = await DbBase().databaseRequest(
          editUser + id, DbBase().patchRequestType,
          body: body);

      printOut("updatedUser $updated");
    } catch (e) {
      printOut("Error updating user $e");
    }
  }

  upgradeAUser() async {
    try {
      var updated = await DbBase().databaseRequest(
          upgradeUser + FirebaseAuth.instance.currentUser!.uid,
          DbBase().patchRequestType);

      printOut("updatedUser $updated");
    } catch (e) {
      printOut("Error upgrading user $e");
    }
  }

  followAUser(String myId, String toFollowId) async {
    try {
      var updated = await DbBase().databaseRequest(
          followUser + myId + "/" + toFollowId, DbBase().patchRequestType);

      await NotificationApi().sendNotification(
          [toFollowId],
          "New follower",
          "${FirebaseAuth.instance.currentUser!.displayName} just followed you",
          "ProfileScreen",
          myId);

      printOut("updatedUser $updated");
    } catch (e, s) {
      printOut("Error following user $e $s");
    }
  }

  unFollowAUser(String myId, String toUnFollowId) async {
    try {
      var updated = await DbBase().databaseRequest(
          unFollowUser + myId + "/" + toUnFollowId, DbBase().patchRequestType);

      printOut("updatedUser $updated");
    } catch (e, s) {
      printOut("Error following user $e $s");
    }
  }

  static authenticate(data, String type) async {
    Helper.debug("data $data");
    Helper.debug("type $type");
    var response;
    if (type == "register") {
      response = await DbBase().databaseRequest(
          config.register, DbBase().postRequestType,
          body: data);
    } else {
      response = await DbBase().databaseRequest(
          config.authenticatation, DbBase().postRequestType,
          body: data);
    }

    printOut(response);
    return jsonDecode(response);
  }

  static Future<UserModel> getUserById() async {
    var response = await Api.callApi(
        method: config.get,
        endpoint: config.users + FirebaseAuth.instance.currentUser!.uid);

    printOut(response);

    return UserModel.fromJson(response);
  }

  static Future<List<Address>> getAddressesFromUserId() async {
    List<dynamic> response = await Api.callApi(
        method: config.get,
        endpoint: config.addresses + FirebaseAuth.instance.currentUser!.uid);
    return response.map((e) => Address.fromJson(e)).toList();
  }

  static getAddressFromId(String addressId) async {
    var response = await Api.callApi(
        method: config.get,
        endpoint: config.address + FirebaseAuth.instance.currentUser!.uid);
    return Address.fromJson(response);
  }

  static addAddressForCurrentUser(Address newAddress) async {
    var response = await Api.callApi(
        method: config.post,
        endpoint: config.address,
        body: newAddress.toJson());
    return response;
  }

  static deleteAddressForCurrentUser(String addressId) async {
    var response = await DbBase().databaseRequest(
        config.address + addressId, DbBase().deleteRequestType);
    return jsonDecode(response)["success"];
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return "user/display_picture/$currentUserUid";
  }

  static updateAddressForCurrentUser(Address newAddress) async {
    var response = await Api.callApi(
        method: config.put,
        endpoint: config.address + newAddress.id,
        body: newAddress.toJson());
    Helper.debug("updateAddressForCurrentUser ${response}");
    return response;
  }

  static uploadDisplayPictureForCurrentUser(String downloadUrl) async {
    await DbBase().databaseRequest(
        config.users + FirebaseAuth.instance.currentUser!.uid,
        DbBase().patchRequestType,
        body: {"profilePhoto": downloadUrl});

    return true;
  }

  static removeDisplayPictureForCurrentUser() {}

  static addFavorite(String s) {}

  static getMyFavorites() async {
    var response = await DbBase().databaseRequest(
      favorite + FirebaseAuth.instance.currentUser!.uid,
      DbBase().getRequestType,
    );
    return jsonDecode(response);
  }

  static saveFovite(String productId) async {
    var response = await DbBase().databaseRequest(
        favorite + FirebaseAuth.instance.currentUser!.uid,
        DbBase().postRequestType,
        body: {
          "productId": [productId]
        });
    return jsonDecode(response);
  }

  static deleteFromFavorite(String productId) async {
    var response = await DbBase().databaseRequest(
        favorite + Get.find<FavoriteController>().favoritekey.value,
        DbBase().deleteRequestType,
        body: {
          "productId": [productId]
        });
    return jsonDecode(response);
  }
}
