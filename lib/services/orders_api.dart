import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/services/client.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

import 'end_points.dart';

class OrderApi {
  static checkOut(Order order, String productId) async {
    Get.find<CheckOutController>().msg.value = "";
    var responsecheck = await DbBase().databaseRequest(
        singleproductqtycheck + productId, DbBase().postRequestType,
        body: {"productId": productId, "quantity": order.quantity});
    var dd = jsonDecode(responsecheck);
    if (dd["status"] == true) {
      var response = await DbBase().databaseRequest(
          config.orders + FirebaseAuth.instance.currentUser!.uid,
          DbBase().postRequestType,
          body: {
            "order": [order.toJson()]
          });

      printOut("Checkout response $response");

      return jsonDecode(response);
    } else {
      Get.find<CheckOutController>().msg.value = "Not in stock";
      return dd;
    }
  }

  updateOrder(Map<String, dynamic> body, String id) async {
    try {
      var orderResponse = await DbBase().databaseRequest(
          updateOrders + id, DbBase().patchRequestType,
          body: body);
      printOut("orderResponse $orderResponse");
    } catch (e) {
      printOut("Error updateOrder  $e");
    }
  }
}
