import 'package:fluttergistshop/services/api.dart';
import 'package:fluttergistshop/services/configs.dart' as config;

import 'helper.dart';

class ApiCalls {
  static Future<Map<String, dynamic>> authenticate(data, String type) async {
    Helper.debug("data $data");
    var response;
    if (type == "register") {
      response = await Api.callApi(
          method: config.post, endpoint: config.register, body: data);
    } else {
      response = await Api.callApi(
          method: config.post, endpoint: config.authenticatation, body: data);
    }
    Helper.debug("response $response");
    return response;
  }
}
