import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/authenticate.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/auth/login.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:fluttergistshop/services/api_calls.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/utils/Functions.dart';
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
      Map<String, dynamic> user = await ApiCalls.authenticate(auth, "register");

      if (user["status"] == 400) {
        error.value = user["message"];
      } else {
        UserModel userModel = UserModel.fromJson(user["data"]);
        return signInWithCustomToken(
            userModel.userName!, user["authtoken"], user["accessToken"]);
      }
    } finally {
      isLoading(false);
    }
  }

  Future authenticate() async {
    try {
      isLoading(true);
      Map<String, dynamic> login = Authenticate(
              email: emailFieldController.text,
              password: passwordFieldController.text)
          .toJson();
      printOut(login);
      Map<String, dynamic> user = await ApiCalls.authenticate(login, "login");
      Helper.debug(user["success"]);
      if (user["success"] == false) {
        error.value = "Check email and password";
      } else {
        UserModel userModel = UserModel.fromJson(user["data"]);
        this.usermodel.value = usermodel as UserModel?;
        return signInWithCustomToken(
            userModel.userName!, user["authtoken"], user["accessToken"]);
      }
    } finally {
      isLoading(false);
    }
  }

  signInWithCustomToken(
      String username, String authtoken, String accesstoken) async {
    try {
      var result = await FirebaseAuth.instance.signInWithCustomToken(authtoken);
      print("result $result");
      if (result.user != null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("access_token", accesstoken);

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

  handleAuth() {
    return FutureBuilder(
      future: ApiCalls.getUserById(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: primarycolor,
            body: Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
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
