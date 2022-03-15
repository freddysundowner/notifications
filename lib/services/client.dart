import 'dart:convert';
import 'dart:io';

import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class DbBase {
  var postRequestType = "POST";
  var getRequestType = "GET";
  var patchRequestType = "PUT";
  var deleteRequestType = "DELETE";

  databaseRequest(
      String link, String type, {Map<String, dynamic>? body}) async {

    _tryConnection();
    try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = "eyJhbGciOiJIUzI1NiJ9.Z3JhY2VAZ21haWwuY29t.UkGGW9q_ejUXJiFJyJRzWtvXG68y6NWx5WvR4n6T_z8";

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + token
    };

    var request = http.Request(type, Uri.parse(link));

    printOut("${request.method} ${request.url}");

    if ( body != null ) {
      request.body = json.encode(body);
    }

    request.headers.addAll(headers);

    printOut(request.toString());

      http.StreamedResponse response = await request.send();


      if (response.statusCode == 404) {

        //  AuthAPI().getToken();

        printOut("Error 404");

      }

      return response.stream.bytesToString();
    } catch(e, s) {
      printOut("Error on api $e $s");
    }

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