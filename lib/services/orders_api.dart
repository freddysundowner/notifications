import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:fluttergistshop/utils/functions.dart';

class OrderApi {
  static checkOut(Order order) async {
    var response = await Api.callApi(
        method: config.post,
        endpoint: config.orders + FirebaseAuth.instance.currentUser!.uid,
        body: {
          "order": [order.toJson()]
        });

    printOut("Checkout response $response");
    return response;
  }
}
