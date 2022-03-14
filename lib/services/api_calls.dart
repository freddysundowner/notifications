import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:fluttergistshop/utils/Functions.dart';

import 'helper.dart';

class ApiCalls {
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

    printOut(UserModel.fromJson(response).userName);

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

  static updateAddressForCurrentUser(Address newAddress) async {
    var response = await Api.callApi(
        method: config.put,
        endpoint: config.address + newAddress.id,
        body: newAddress.toJson());
    Helper.debug("updateAddressForCurrentUser ${response}");
    return response;
  }

  static checkOut(Order order) async {
    var response = await Api.callApi(
        method: config.post, endpoint: config.address, body: order.toJson());
    return response;
  }

  static updateProductsImages(String productId, List<String> downloadUrls) {}

  static String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }

  static saveProduct(Map<String, dynamic> productdata) async {
    var response = await Api.callApi(
        method: config.post, endpoint: config.address, body: productdata);
    return response;
  }

  static saveShop(Map<String, dynamic> shopdata) async {
    var response = await Api.callApi(
        method: config.post, endpoint: config.shop, body: shopdata);
    return response;
  }
}
