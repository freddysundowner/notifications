import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/utils/Functions.dart';
import 'client.dart';
import 'end_points.dart';

// api //
class UserAPI {
  getAllUsers() async {
    var users =
        await DbBase().databaseRequest(allUsers, DbBase().getRequestType);

    return jsonDecode(users);
  }

  static Future<Map<String, dynamic>> authenticate(data, String type) async {
    Helper.debug("data $data");
    Helper.debug("type $type");
    var response;
    if (type == "register") {
      response = await Api.callApi(
          method: config.post, endpoint: config.register, body: data);
    } else {
      response = await Api.callApi(
          method: config.post, endpoint: config.authenticatation, body: data);
    }
    return response;
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
    print(
        "uploadDisplayPictureForCurrentUser ${{"profilePhoto": downloadUrl}}");
    await DbBase().databaseRequest(
        config.users + FirebaseAuth.instance.currentUser!.uid,
        DbBase().patchRequestType,
        body: {"profilePhoto": downloadUrl});

    return true;
  }

  static removeDisplayPictureForCurrentUser() {}
}
