import 'dart:convert';
import 'dart:io';

import 'package:fluttergistshop/utils/Functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class DbBase {
  var postRequestType = "POST";
  var getRequestType = "GET";
  var patchRequestType = "PATCH";
  var deleteRequestType = "DELETE";

  databaseRequest(
      String link, String type, {Map<String, dynamic>? body}) async {

    _tryConnection();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = "eyJhbGciOiJIUzI1NiJ9.Z3JhY2VAZ21haWwuY29t.UkGGW9q_ejUXJiFJyJRzWtvXG68y6NWx5WvR4n6T_z8";

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + token
    };

    var request = http.Request(type, Uri.parse(link));

    if ( body != null ) {
      request.body = json.encode(body);
    }

    request.headers.addAll(headers);


    http.StreamedResponse response = await request.send();


    if (response.statusCode == 404) {

    //  AuthAPI().getToken();

    }

    return response.stream.bytesToString();
  }


  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      if(response.isEmpty) {

        Get.snackbar('', "Check your internet connection");


        printOut(response.toString());

      }
    } on SocketException catch (e) {

       printOut(e.message);


      Get.snackbar('', "Check your internet connection");
    }
  }

}