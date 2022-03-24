import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/models/authenticate.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/auth/login.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  Rxn<UserModel> usermodel = Rxn<UserModel>();
  UserModel? get currentuser => usermodel.value;
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController fnameFieldController = TextEditingController();
  final TextEditingController lnameFieldController = TextEditingController();
  final TextEditingController usernameFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController =
      TextEditingController();

  var error = "".obs;
  var isLoading = true.obs;

  Rx<File> _chosenImage = Rx(File(""));
  File get chosenImage => _chosenImage.value;
  set setChosenImage(File img) {
    _chosenImage.value = img;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future register() async {
    try {
      isLoading(true);
      Map<String, dynamic> auth = Authenticate(
        email: emailFieldController.text,
        password: passwordFieldController.text,
        userName: usernameFieldController.text,
        firstName: fnameFieldController.text,
        lastName: lnameFieldController.text,
      ).toJson();
      Map<String, dynamic> user = await UserAPI.authenticate(auth, "register");

      if (user["success"] == false) {
        error.value = user["info"]["message"];
      } else {
        UserModel userModel = UserModel.fromJson(user["data"]);
        try {
          usermodel.value = userModel;
        } catch (e) {
          printOut("error saving user model to controller on login $e");
        }

        return signInWithCustomToken(
            userModel.userName!, user["authtoken"], user["accessToken"]);
      }

    } catch(e, s) {
      printOut("Error authenticating $e $s");
    } finally {
      isLoading(false);
    }
  }

  Future authenticate() async {
    // try {
    isLoading(true);
    Map<String, dynamic> login = Authenticate(
            email: emailFieldController.text,
            password: passwordFieldController.text)
        .toJson();
    Map<String, dynamic> user = await UserAPI.authenticate(login, "login");
    Helper.debug(user["success"]);
    if (user["success"] == false) {
      error.value = "Check email and password";
    } else {
      try {
        UserModel userModelFromApi = UserModel.fromJson(user["data"]);
        usermodel.value = userModelFromApi;
        return signInWithCustomToken(
            userModelFromApi.userName!, user["authtoken"], user["accessToken"]);
      } catch (e) {
        printOut("error saving user model to controller on login $e");
      }
    }
    // } catch (e) {
    //   printOut("Error after auth $e");
    //   isLoading(false);
    // }
  }

  signInWithCustomToken(
      String username, String authtoken, String accesstoken) async {
    try {
      var result = await FirebaseAuth.instance.signInWithCustomToken(authtoken);
      printOut("result signIn $result");
      if (result.user != null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("access_token", accesstoken);

        return Get.offAll(() => HomePage());
      } else {
        printOut("User null");
      }
    } catch (e) {
      printOut("error " + e.toString());
      return "null";
    }
  }

  signOut() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Get.offAll(Login());

    dispose();
    ChatController().dispose();

  }

  handleAuth() {
    return FutureBuilder(
      future: UserAPI.getUserById(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: primarycolor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData == true) {
          usermodel.value = snapshot.data as UserModel?;
          return HomePage();
        }
        return Login();
      },
    );
  }

}
