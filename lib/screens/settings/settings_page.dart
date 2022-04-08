import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:fluttergistshop/screens/orders/orders_sceen.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';


class SettingsPage extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();
  AuthController authController = Get.find<AuthController>();
  final RoomController _homeController = Get.find<RoomController>();
  String socialLinkError = '';
  final _formKey = GlobalKey<FormState>();

  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _homeController.onChatPage.value = false;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 20.0,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setSocialLink('twitter', context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Twitter",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () => setSocialLink('instagram', context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Instagram",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () => setSocialLink('facebook', context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Facebook",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () => setSocialLink('linkedIn', context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "LinkedIn",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _userController.getUserOrders();
                        Get.to(OrdersScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Orders",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        Get.to(ManageAddressesScreen(false));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Addresses",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "What's new",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "FAQ/Contact us",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Community guidelines",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              Container(
                width: 0.9.sw,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: InkWell(
                  onTap: () {
                    Get.defaultDialog(
                        onConfirm: () => authController.signOut(),
                        title: "Log out",
                        content:
                            const Text("Are you sure you want to log out?"),
                        onCancel: () => Get.back(),
                        textConfirm: "LogOut");
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setSocialLink(String type, BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      builder: (context) {
        UserModel user = authController.usermodel.value!;

        if (user.twitter != null) {
          twitterController.text = user.twitter!;
        }
        if (user.linkedIn != null) {
          linkedInController.text = user.linkedIn!;
        }
        if (user.instagram != null) {
          instagramController.text = user.instagram!;
        }
        if (user.facebook != null) {
          facebookController.text = user.facebook!;
        }

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 20, color: Colors.black),
                      ),
                      Center(
                          child: Text(
                        type.capitalizeFirst!,
                        style: TextStyle(fontSize: 20.sp, color: Colors.black),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: type == 'twitter'
                                ? twitterController
                                : type == 'instagram'
                                    ? instagramController
                                    : type == 'facebook'
                                        ? facebookController
                                        : linkedInController,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else {
                                var link = type == 'twitter'
                                    ? twitterController.text
                                    : type == 'instagram'
                                        ? instagramController.text
                                        : type == 'facebook'
                                            ? facebookController.text
                                            : linkedInController.text;
                                return validateLink(link, type);
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: 'Paste a link to your account',
                              hintStyle: TextStyle(
                                fontSize: 16.sp,
                              ),
                              errorText: socialLinkError,
                            ),
                            keyboardType: TextInputType.url,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        printOut("Validating 1");
                        var link = type == 'twitter'
                            ? twitterController.text
                            : type == 'instagram'
                                ? instagramController.text
                                : type == 'facebook'
                                    ? facebookController.text
                                    : linkedInController.text;

                        saveSocialAccount(type, link);
                      } else {
                        printOut("Validating 1");
                      }
                    },
                    child: Container(
                      height: 0.08.sh,
                      width: 0.8.sw,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  saveSocialAccount(String type, link) async {
    var saved = await UserAPI()
        .updateUser({type: link}, FirebaseAuth.instance.currentUser!.uid);

    if (type == 'twitter') {
      authController.usermodel.value!.twitter = link;
    } else if (type == 'instagram') {
      authController.usermodel.value!.instagram = link;
    } else if (type == 'facebook') {
      authController.usermodel.value!.facebook = link;
    } else if (type == 'linkedIn') {
      authController.usermodel.value!.linkedIn = link;
    }

    printOut("User saved, $saved");
    Get.back();
  }

  String? validateLink(String link, String type) {
    String? socialLinkError;
    if (Uri.parse(link).host != '') {
      socialLinkError = null;
    } else {
      socialLinkError = "Link not correct";
    }

    return socialLinkError;
  }
}
