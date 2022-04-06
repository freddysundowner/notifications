import 'dart:convert';
import 'dart:io';

import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'configs.dart';

class DbBase {
  var postRequestType = "POST";
  var getRequestType = "GET";
  var patchRequestType = "PUT";
  var deleteRequestType = "DELETE";

  databaseRequest(String link, String type,
      {Map<String, dynamic>? body}) async {
    // _tryConnection();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + (token ?? "")
      };

      var request = http.Request(type, Uri.parse(link));

      printOut("request ${request.method} ${request.url}");

      if (body != null) {
        request.body = json.encode(body);
        printOut("body ${request.body}");
      }

      request.headers.addAll(headers);

      printOut(request.toString());

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 404) {
        //  AuthAPI().getToken();

        printOut("Error 404");
      }

      return response.stream.bytesToString();
    } catch (e, s) {
      printOut("Error on api $link $e $s");
    }
  }

  Future<void> tryConnection() async {
    try {
      final response = await InternetAddress.lookup(api_url);

      printOut(response.toString());
      if (response.isEmpty) {
        Get.snackbar('', "Check your internet connection", backgroundColor: sc_snackBar,);

        printOut(response.toString());
      }
    } on SocketException catch (e) {
      printOut(" error accessing internet " + e.message);

      Get.snackbar('', "Check your internet connection", backgroundColor: sc_snackBar,);
    } catch (e) {
      printOut(" error accessing internet catch $e");
    }
  }
}
