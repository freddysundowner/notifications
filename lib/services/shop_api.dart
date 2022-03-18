import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;

import 'client.dart';
import 'end_points.dart';

class ShopApi {
  static saveShop(Map<String, dynamic> shopdata) async {
    var response = await Api.callApi(
        method: config.post,
        endpoint: config.shop + FirebaseAuth.instance.currentUser!.uid,
        body: shopdata);
    print(response);
    return jsonDecode(response);
  }

  static updateShop(Map<String, dynamic> shopdata, String shopid) async {
    var response = await DbBase().databaseRequest(
        config.updateshop + shopid, DbBase().patchRequestType,
        body: shopdata);
    // var response = await Api.callApi(
    //     method: config.put,
    //     endpoint: config.updateshop + shopid,
    //     body: shopdata);
    print("updateShop $response");
    return jsonDecode(response);
  }

  static getProductsByShop(String shopid) async {
    List<dynamic> response = await Api.callApi(
        method: config.get, endpoint: config.products + shopid);
    print(response);
    return response;
  }

  searchShop(String text) async {
    var shops = await DbBase()
        .databaseRequest(searchShopByName + text, DbBase().getRequestType);

    return jsonDecode(shops);
  }

  getAllShops() async {
    var shops =
        await DbBase().databaseRequest(allShops, DbBase().getRequestType);

    return jsonDecode(shops);
  }

  static String getPathForShop(String shopid) {
    return "shop/$shopid";
  }
}
