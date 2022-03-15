import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;

class ShopApi {
  static saveShop(Map<String, dynamic> shopdata) async {
    var response = await Api.callApi(
        method: config.post,
        endpoint: config.shop + FirebaseAuth.instance.currentUser!.uid,
        body: shopdata);
    print(response);
    return response;
  }

  static updateShop(Map<String, dynamic> shopdata, String shopid) async {
    var response = await Api.callApi(
        method: config.put,
        endpoint: config.updateshop + shopid,
        body: shopdata);
    print(response);
    return response;
  }

  static getProductsByShop(String shopid) async {
    List<dynamic> response = await Api.callApi(
        method: config.get, endpoint: config.products + shopid);
    print(response);
    return response;
  }
}
