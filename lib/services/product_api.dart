import 'dart:convert';

import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:get/get.dart';

import 'client.dart';
import 'end_points.dart';

class ProductPI {
  getAllRooms() async {
    var rooms =
        await DbBase().databaseRequest(allRooms, DbBase().getRequestType);

    return jsonDecode(rooms);
  }

  static updateProduct(
      Map<String, dynamic> productdata, String productid) async {
    var response = await Api.callApi(
        method: config.put,
        endpoint: config.updateproduct + productid,
        body: productdata);
    print(response);
    return response;
  }

  getUserProducts(String userId) async {
    var products = await DbBase()
        .databaseRequest(userProducts + userId, DbBase().getRequestType);
    return jsonDecode(products);
  }

  static String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }

  static saveProduct(Map<String, dynamic> productdata) async {
    var response = await Api.callApi(
        method: config.post,
        endpoint: config.products +
            Get.find<AuthController>().currentuser!.shopId!.id!,
        body: productdata);
    return response;
  }

  static Future<bool> updateProductsImages(
      String productId, List<dynamic> imgUrl) async {
    print("updateProductsImages $imgUrl");
    print("productId $productId");
    await DbBase().databaseRequest(
        config.updateproductimages + productId, DbBase().patchRequestType,
        body: {"images": imgUrl});

    return true;
  }
}
