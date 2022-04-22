import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
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
  getAllUsers(int pageNumber) async {
    try {
      var users = await DbBase().databaseRequest(
          allUsers + pageNumber.toString(), DbBase().getRequestType);

      var decodedUsers = jsonDecode(users);
      var finalUsers = [];

      for (var a in decodedUsers.elementAt(0)["data"]) {
        a["shopId"] = a["shopId"].isEmpty ? null : a["shopId"].elementAt(0);
        finalUsers.add(a);
      }

      printOut("users $finalUsers");
      return finalUsers;
    } catch (e, s) {
      printOut("$e $s");
    }
  }

  getUserProfile(String uid) async {
    var user =
        await DbBase().databaseRequest(userById + uid, DbBase().getRequestType);

    if (user == null) {
      return null;
    } else {
      print("-----------fred---------- ${jsonDecode(user)}");
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

  getOrderById(String orderId) async {
    printOut("order");
    var order = await DbBase()
        .databaseRequest(oneOrder + orderId, DbBase().getRequestType);

    printOut("order by id ${jsonDecode(order)}");
    return jsonDecode(order);
  }
  getUserOrders(String uid) async {
    var orders = await DbBase()
        .databaseRequest(userOrders + uid, DbBase().getRequestType);

    return jsonDecode(orders);
  }

  getUserOrdersPaginated(String uid, int pageNumber) async {
    var orders = await DbBase()
        .databaseRequest(userOrdersPaginated + "$uid/$pageNumber", DbBase().getRequestType);

    var decodedOrders = jsonDecode(orders);
    var finalOrders = [];

    for (var a in decodedOrders.elementAt(0)["data"]) {
      a["customerId"] = a["customerId"].isEmpty ? null : a["customerId"].elementAt(0);
      a["customerId"]["shopId"] = a["customerId"]["shopId"].isEmpty ? null : a["customerId"]["shopId"].elementAt(0);
      a["shippingId"] = a["shippingId"].isEmpty ? null : a["shippingId"].elementAt(0);
      a["billingId"] = a["billingId"].isEmpty ? null : a["billingId"].elementAt(0);
      a["itemId"] = a["itemId"].isEmpty ? null : a["itemId"].elementAt(0);
      a["itemId"]["productId"] = a["itemId"]["productId"].isEmpty ? null : a["itemId"]["productId"].elementAt(0);
      a["itemId"]["productId"]["ownerId"] = a["itemId"]["productId"]["ownerId"].isEmpty ? null : a["itemId"]["productId"]["ownerId"].elementAt(0);
      a["itemId"]["productId"]["ownerId"]["shopId"] = a["itemId"]["productId"]["ownerId"]["shopId"].isEmpty ? null : a["itemId"]["productId"]["ownerId"]["shopId"].elementAt(0);

      finalOrders.add(a);
    }

    return finalOrders;
  }

  getShopOrders(String id) async {
    var orders = await DbBase()
        .databaseRequest(shopOrders + id, DbBase().getRequestType);

    return jsonDecode(orders);
  }

  getShopOrdersPaginated(String id, int pageNumber) async {
    var orders = await DbBase()
        .databaseRequest(shopOrdersPaginated + "$id/$pageNumber", DbBase().getRequestType);

    var decodedOrders = jsonDecode(orders);
    var finalOrders = [];

    for (var a in decodedOrders.elementAt(0)["data"]) {
      a["customerId"] = a["customerId"].isEmpty ? null : a["customerId"].elementAt(0);
      a["customerId"]["shopId"] = a["customerId"]["shopId"].isEmpty ? null : a["customerId"]["shopId"].elementAt(0);
      a["shippingId"] = a["shippingId"].isEmpty ? null : a["shippingId"].elementAt(0);
      a["billingId"] = a["billingId"].isEmpty ? null : a["billingId"].elementAt(0);
      a["itemId"] = a["itemId"].isEmpty ? null : a["itemId"].elementAt(0);
      a["itemId"]["productId"] = a["itemId"]["productId"].isEmpty ? null : a["itemId"]["productId"].elementAt(0);
      a["itemId"]["productId"]["ownerId"] = a["itemId"]["productId"]["ownerId"].isEmpty ? null : a["itemId"]["productId"]["ownerId"].elementAt(0);
      a["itemId"]["productId"]["ownerId"]["shopId"] = a["itemId"]["productId"]["ownerId"]["shopId"].isEmpty ? null : a["itemId"]["productId"]["ownerId"]["shopId"].elementAt(0);

      finalOrders.add(a);
    }

    return finalOrders;
  }

  updateUser(Map<String, dynamic> body, String id) async {
    try {
      printOut("updating user $body");

      var updated = await DbBase().databaseRequest(
          editUser + id, DbBase().patchRequestType,
          body: body);

      printOut("updated user ${updated}");
      // UserModel userModel = UserModel.fromJson(jsonDecode(updated)["user"]);
      // Get.find<AuthController>().usermodel.value = userModel;

      printOut("updatedUser $updated");
    } catch (e, s) {
      printOut("Error updating user $e $s");
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

    UserModel userModel = UserModel.fromJson(response);
    Get.find<AuthController>().usermodel.value = userModel;

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

  static friendsToInvite() async {
    print("friendsToInvite");
    var response = await DbBase().databaseRequest(
        followersfollowing + FirebaseAuth.instance.currentUser!.uid,
        DbBase().getRequestType);
    return jsonDecode(response);
  }

  static searchFriends(String searchText) async {
    var response = await DbBase().databaseRequest(
        followersfollowingsearch +
            FirebaseAuth.instance.currentUser!.uid +
            "/" +
            searchText,
        DbBase().getRequestType);
    return jsonDecode(response);
  }
}
