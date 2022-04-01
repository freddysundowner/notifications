import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:fluttergistshop/services/local_files_access_service.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../utils/utils.dart';

enum NewShopState { Default, DB, PICK }

class NewShop extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  NewShopState state = NewShopState.Default;
  bool selected = false;

  void showSnackBar(String string, String color) {
    var clr = Colors.teal;
    if (color == "red") {
      clr = Colors.red;
    }
    var snackBar = new SnackBar(
      content: new Text(
        string,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      backgroundColor: clr,
      action: SnackBarAction(
        label: "Ok",
        textColor: Colors.white,
        onPressed: () {},
      ),
      elevation: 4.0,
    );
    if (_scaffoldKey.currentState != null)
      _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  Widget buildDisplayPictureAvatar(BuildContext context) {
    ImageProvider? backImage;
    if (shopController.chosenImage.path != "") {
      print("one");
      backImage = MemoryImage(shopController.chosenImage.readAsBytesSync());
    } else if (authController.currentuser!.shopId != null &&
        authController.currentuser!.shopId!.image != null &&
        authController.currentuser!.shopId!.image!.isNotEmpty) {
      print("two ${authController.currentuser!.shopId!.image}");
      final String? url = authController.currentuser!.shopId!.image;
      if (url != null) backImage = NetworkImage(url);
    }
    print("backImage $backImage");
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.grey,
      backgroundImage: backImage ?? AssetImage(imageplaceholder),
    );
  }

  void getImageFromUser(BuildContext context) async {
    String path;
    String snackbarMessage = "Image picked";
    try {
      path = await choseImageFromLocalFiles(context,
          aspectration: CropAspectRatio(ratioX: 3, ratioY: 2));
      if (path == null) {
        throw LocalImagePickingUnknownReasonFailureException();
      }
    } finally {
      if (snackbarMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
    if (path == null) {
      return;
    }
    shopController.setChosenImage = File(path);
    // bodyState.setChosenImage = File(path);
  }

  @override
  Widget build(BuildContext context) {
    print(
        "authController.currentuser!.shopId ${authController.currentuser!.shopId}");
    if (authController.currentuser!.shopId != null) {
      shopController
          .getShopById(authController.currentuser!.shopId?.id.toString());

      shopController.nameController.text =
          shopController.currentShop.value.name!;

      shopController.emailController.text =
          shopController.currentShop.value.email!;

      shopController.mobileController.text =
          shopController.currentShop.value.phoneNumber!;

      shopController.daddressController.text =
          shopController.currentShop.value.location!;

      shopController.descriptionController.text =
          shopController.currentShop.value.description!;
    } else {
      shopController.nameController.text = "";

      shopController.emailController.text = "";

      shopController.mobileController.text = "";

      shopController.daddressController.text = "";

      shopController.descriptionController.text = "";
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(" Shop Details"),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String snackbarMessage = "";
                var response;
                if (authController.currentuser!.shopId != null) {
                  response = shopController
                      .updateShop(authController.currentuser!.shopId!.id!);
                }
                if (authController.currentuser!.shopId == null ||
                    authController.currentuser!.shopId == "") {
                  response = shopController.saveShop();
                }
                try {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AsyncProgressDialog(
                        response,
                        message: Text("Creating shop"),
                        onError: (e) {
                          snackbarMessage = e.toString();
                        },
                      );
                    },
                  );
                  snackbarMessage = shopController.error.value;
                } finally {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(snackbarMessage),
                    ),
                  );
                  if (shopController.error.value.isEmpty) {
                    print(
                        "shopController.error.value ${shopController.error.value}");
                    authController.usermodel.value = await UserController()
                        .getUserProfile(authController.usermodel.value!.id!);
                    Get.back();
                  }
                }
              }
            },
            child: Center(
              child: Text(
                authController.currentuser!.shopId != null ? "UPDATE" : "SAVE",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: <Widget>[
              Container(
                  child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: buildDisplayPictureAvatar(context),
                      onTap: () {
                        getImageFromUser(context);
                      },
                    ),
                  ),
                ],
              )),
              Form(
                  key: _formKey,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Shop Name",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: sc_ItemTitleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          controller: shopController.nameController,
                          toolbarOptions: ToolbarOptions(
                            paste: true,
                            selectAll: false,
                          ),
                          validator: (value) {
                            if (shopController.nameController.text.isEmpty) {
                              return "Shop name is required";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            fillColor: sc_InputBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          textCapitalization: TextCapitalization.words,
                          autocorrect: false,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: sc_ItemTitleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          controller: shopController.emailController,
                          validator: (value) {
                            if (shopController.emailController.text.isEmpty) {
                              return kEmailNullError;
                            } else if (!emailValidatorRegExp.hasMatch(
                                shopController.emailController.text)) {
                              return kInvalidEmailError;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            fillColor: sc_InputBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Mobile No.",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: sc_ItemTitleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (shopController.mobileController.text.isEmpty) {
                              return "phone number is required";
                            }
                            return null;
                          },
                          controller: shopController.mobileController,
                          toolbarOptions: ToolbarOptions(
                            paste: true,
                            selectAll: false,
                          ),
                          decoration: InputDecoration(
                            fillColor: sc_InputBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: sc_ItemTitleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextField(
                          controller: shopController.daddressController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 2,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: sc_InputBackgroundColor,
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: sc_ItemTitleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextField(
                          controller: shopController.descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: sc_InputBackgroundColor,
                            contentPadding: EdgeInsets.all(15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: sc_InputBackgroundColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          );
        }),
      ),
    );
  }
}
