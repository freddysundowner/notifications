import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/main.dart';
import 'package:fluttergistshop/services/configs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'helper.dart';

class Api {
  static var client = http.Client();
  static callApi(
      {required String method, body, required String endpoint}) async {
    _tryConnection();

    var url = Uri.parse(endpoint);
    if (method == get) {
      return _callGet(url: url);
    }
    if (method == post) {
      return _callPost(body: body!, url: url);
    }
    if (method == put) {
      return _callPut(body: body!, url: url);
    }
  }

  static _callGet({required Uri url}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");
      Map<String, String> headers = {};
      if (token != null) {
        headers = {'Authorization': "Bearer " + token};
      }
      Helper.debug("headers ${headers}");
      Helper.debug("url ${url}");
      final response = await client.get(url, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  static _callPost({Map<String, dynamic>? body, required Uri url}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");
      Map<String, String> headers = {};
      if (token != null) {
        headers = {'Authorization': "Bearer " + token};
      }
      Helper.debug("headers ${headers}");
      Helper.debug("url ${url}");
      Helper.debug("body ${body}");
      final response = await client.post(url, body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      Helper.debug("error _callPost ${e}");
      return null;
    }
  }

  static _callPut({Map<String, dynamic>? body, required Uri url}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");
      Map<String, String> headers = {};
      if (token != null) {
        headers = {'Authorization': "Bearer " + token};
      }
      Helper.debug("headers ${headers}");
      Helper.debug("url ${url}");
      Helper.debug("body ${body}");
      final response = await client.put(url, body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      Helper.debug("error _callPost ${e}");
      return null;
    }
  }

  static Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      if (response.isEmpty) {
        final snackBar = SnackBar(
          content: const Text('Check your internet connection'),
          action: SnackBarAction(
            onPressed: () {
              // Some code to undo the change.
            },
            label: '',
          ),
        );

        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(snackBar);
      }
    } on SocketException catch (e) {
      final snackBar = SnackBar(
        content: const Text('Check your internet connection'),
        action: SnackBarAction(
          onPressed: () {
            // Some code to undo the change.
          },
          label: '',
        ),
      );

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
    }
  }
}
