import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/connection_error.dart';
import 'package:fluttergistshop/controllers/activity_controller.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/controllers/favorite_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/controllers/wallet_controller.dart';
import 'package:fluttergistshop/models/authenticate.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/auth/login.dart';
import 'package:fluttergistshop/screens/home/main_page.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/services/socket_io.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/connection_state.dart';

late CustomSocketIO customSocketIO = CustomSocketIO();

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
  final RoomController _homeController = Get.put(RoomController());

  var connectionstate = true.obs;

  var error = "".obs;
  var isLoading = true.obs;
  var passwordVisible = false.obs;

  Rx<File> _chosenImage = Rx(File(""));
  File get chosenImage => _chosenImage.value;
  set setChosenImage(File img) {
    _chosenImage.value = img;
  }
  var renewUpgrade = true.obs;

  final ConnectionStateChecker _connectivity = ConnectionStateChecker.instance;

  @override
  void onInit() {
    super.onInit();

    customSocketIO.init(
        onSocketConnected: (data) => print("onSocketConnected"));

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
          titleText: const Text(
            "Check your internet connection",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: "InterBold"),
          ),
          margin: const EdgeInsets.all(0),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(hours: 6000),
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

        return Get.offAll(() => MainPage());
      } else {
        printOut("User null");
      }
    } catch (e) {
      printOut("error " + e.toString());
      return "null";
    }
  }

  signOut() async {
    //Remove user from current room
    if (_homeController.currentRoom.value.id != null) {
      await _homeController.leaveRoom(
          OwnerId(id: Get.find<AuthController>().usermodel.value!.id));
    }

    //Remove user notification token
    await UserAPI().updateUser(
        {"notificationToken": ""}, FirebaseAuth.instance.currentUser!.uid);

    FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Get.offAll(Login());

    dispose();
    ChatController().dispose();
    RoomController().dispose();
    CheckOutController().dispose();
    RoomController().dispose();
    ActivityController().dispose();
    FavoriteController().dispose();
    ProductController().dispose();
    ShopController().dispose();
    UserController().dispose();
    WalletController().dispose();
    Get.find<AuthController>().dispose();
  }

  handleAuth() {
    if (FirebaseAuth.instance.currentUser == null) {
      return Login();
    }else {
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
            usermodel.refresh();
            return MainPage();
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
          return ConnectionFailed();
        },
      );
    }
  }

  sendGift(amount) {}
}
