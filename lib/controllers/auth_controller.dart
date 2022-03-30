import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/main.dart';
import 'package:fluttergistshop/models/authenticate.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/auth/login.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:fluttergistshop/services/client.dart';
import 'package:fluttergistshop/services/configs.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/services/socket_io.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/connection_state.dart';

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
  final TextEditingController bioFieldController = TextEditingController();
  var connectionstate = true.obs;

  var error = "".obs;
  var isLoading = true.obs;

  Rx<File> _chosenImage = Rx(File(""));
  File get chosenImage => _chosenImage.value;
  set setChosenImage(File img) {
    _chosenImage.value = img;
  }

  final ConnectionStateChecker _connectivity = ConnectionStateChecker.instance;
  SocketIO _socketIO = new SocketIO();
  @override
  void onInit() {
    super.onInit();

    _socketIO.init(onSocketConnected: (data) => print("onSocketConnected"));

    _socketIO.socketIO.emit("message", "data");

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (source.keys.toList()[0] == ConnectivityResult.mobile ||
          source.keys.toList()[0] == ConnectivityResult.wifi) {
        connectionstate.value = true;
        Get.closeAllSnackbars();
      } else {
        connectionstate.value = false;
        Get.snackbar(
          "",
          "",
          snackPosition: SnackPosition.TOP,
          borderRadius: 0,
          titleText: Text(
            "Check your internet connection",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: "InterBold"),
          ),
          margin: EdgeInsets.all(0),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(hours: 6000),
        );
      }
    });
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
              bio: bioFieldController.text)
          .toJson();
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
    } catch (e, s) {
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

        var userOneSignalId = await OneSignal.shared.getDeviceState();
        await UserAPI().updateUser(
            {"notificationToken": userOneSignalId!.userId},
            FirebaseAuth.instance.currentUser!.uid);

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

        if (FirebaseAuth.instance.currentUser == null) {
          return Login();
        }
        if (connectionstate.value == false) {
          return Scaffold(
              backgroundColor: primarycolor,
              body: Center(
                child: CircularProgressIndicator(),
              ));
        }
        return Container();
      },
    );
  }
}
