import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;

class OrderApi {
  static checkOut(Order order) async {
    var response = await Api.callApi(
        method: config.post, endpoint: config.address, body: order.toJson());
    return response;
  }
}
