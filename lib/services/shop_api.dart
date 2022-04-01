import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;

import 'client.dart';
import 'end_points.dart';

class ShopApi {
  static saveShop(Map<String, dynamic> shopdata) async {
    // var response = await Api.callApi(
    //     method: config.post,
    //     endpoint: config.shop + FirebaseAuth.instance.currentUser!.uid,
    //     body: shopdata);
    var response = await await DbBase().databaseRequest(
        config.shop + FirebaseAuth.instance.currentUser!.uid,
        DbBase().postRequestType,
        body: shopdata);
    print(response);
    return jsonDecode(response);
  }

  static updateShop(Map<String, dynamic> shopdata, String shopid) async {
    var response = await DbBase().databaseRequest(
        config.updateshop + shopid, DbBase().patchRequestType,
        body: shopdata);
    return jsonDecode(response);
  }

  static getProductsByShop(String shopid) async {
    List<dynamic> response = await Api.callApi(
        method: config.get, endpoint: config.products + shopid);
    print(response);
    return response;
  }

  searchItems(String text, String searchOption, {last = ""}) async {
    print({"lastid": last});
    var shops = await DbBase().databaseRequest(
        baseUrl + "/" + searchOption + "/search/" + text,
        DbBase().getRequestType,
        body: {"lastid": last});
    print(jsonDecode(shops));
    return jsonDecode(shops);
  }

  getAllShops() async {
    var shops =
        await DbBase().databaseRequest(allShops, DbBase().getRequestType);

    return jsonDecode(shops);
  }

  getShopById(String? shopId) async {
    var shops = await DbBase()
        .databaseRequest(updateshop + shopId!, DbBase().getRequestType);
    print("getShopById ${updateshop + shopId}");
    return jsonDecode(shops);
  }

  static String getPathForShop(String shopid) {
    return "shop/$shopid";
  }
}
