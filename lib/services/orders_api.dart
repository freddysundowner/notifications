import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/client.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'end_points.dart';

class OrderApi {
  static checkOut(Order order, String productId) async {
    Get.find<CheckOutController>().msg.value = "";
    print({"productId": productId, "quantity": order.quantity});
    var responsecheck = await DbBase().databaseRequest(
        singleproductqtycheck + productId, DbBase().postRequestType,
        body: {"productId": productId, "quantity": order.quantity});
    print(responsecheck);
    var dd = jsonDecode(responsecheck);
    if (dd["status"] == true) {
      var response = await Api.callApi(
          method: config.post,
          endpoint: config.orders + FirebaseAuth.instance.currentUser!.uid,
          body: {
            "order": [order.toJson()]
          });

      printOut("Checkout response $response");

      return response;
    } else {
      Get.find<CheckOutController>().msg.value = "Not in stock";
      return dd;
    }
  }
}
