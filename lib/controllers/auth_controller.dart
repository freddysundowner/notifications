import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/login.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:fluttergistshop/services/api_calls.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  var error = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    signOut();
  }

  Future loginUser() async {
    try {
      isLoading(true);
      Map<String, dynamic> login = new Authenticate(
              email: emailFieldController.text,
              password: passwordFieldController.text)
          .toJson();
      Map<String, dynamic> user = await ApiCalls.authenticate(login);
      Helper.debug(user["success"]);
      if (user["success"] == false) {
        error.value = "Check email and password";
      } else {
        UserModel userModel = UserModel.fromJson(user["data"]);
        return signInWithCustomToken(userModel.userName!, user["authtoken"]);
      }
    } finally {
      isLoading(false);
    }
  }

  signInWithCustomToken(String username, String token) async {
    try {
      var result = await FirebaseAuth.instance.signInWithCustomToken(token);
      print("result $result");
      if (result.user != null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("access_token", token);
        return Get.offAll(() => HomePage());
      } else {
        print("User null");
      }
    } catch (e) {
      print("error " + e.toString());
      return "null";
    }
  }

  signOut() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
