import 'package:firebase_auth/firebase_auth.dart';
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
}
