import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/models/shop.dart';
import 'package:fluttergistshop/services/firestore_files_access_service.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ShopController extends GetxController {
  Rxn<Shop> _shop = Rxn();
  get shop => _shop.value;
  RxString error = "".obs;
  var searchedShops = [].obs;
  var isSearchingShop = false.obs;
  var allShops = [].obs;
  var currentShop = Shop().obs;

  Rx<File> _chosenImage = Rx(File(""));
  File get chosenImage => _chosenImage.value;
  set setChosenImage(File img) {
    _chosenImage.value = img;
  }

  TextEditingController nameController = TextEditingController(),
      mobileController = TextEditingController(),
      descriptionController = TextEditingController(),
      daddressController = TextEditingController(),
      emailController = TextEditingController();


  saveShop() async {
    try {
      Map<String, dynamic> productdata = new Shop(
              name: nameController.text,
              phoneNumber: mobileController.text,
              description: descriptionController.text,
              location: daddressController.text,
              email: emailController.text)
          .toJson();
      var response = await ShopApi.saveShop(productdata);
      error.value = "";
      if (response["success"]) {
        final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
            chosenImage, ShopApi.getPathForShop(response["data"]["_id"]));
        await ShopApi.updateShop(
            {"image": downloadUrl}, response["data"]["_id"]);
      } else {
        error.value = response["message"];
      }
      return response;
    } catch (e, s) {
      printOut("Error saving product $e $s");
    }
  }

  search() {}

  updateShop(String id) async {
    try {
      String imageurl = Get.find<AuthController>().currentuser!.shopId!.image!;
      if (chosenImage.path.isNotEmpty) {
        imageurl = await FirestoreFilesAccess().uploadFileToPath(
            chosenImage,
            ShopApi.getPathForShop(
                Get.find<AuthController>().currentuser!.shopId!.id!));
      }
      Map<String, dynamic> productdata = new Shop(
              name: nameController.text,
              phoneNumber: mobileController.text,
              description: descriptionController.text,
              image: imageurl,
              location: daddressController.text,
              email: emailController.text)
          .toJson();
      print("productdata $productdata");
      var response = await ShopApi.updateShop(productdata, id);
      error.value = "";
      if (response["success"]) {
        Get.back();
      } else {
        error.value = response["message"];
      }
      return response;
    } catch (e) {}
  }

  getShops() async {
    if (allShops.isEmpty) {
      try {
        isSearchingShop.value = true;

        var shops = await ShopApi().getAllShops();

        if (shops != null) {
          allShops.value = shops;
        } else {
          allShops.value = [];
        }
        allShops.refresh();
        isSearchingShop.value = false;

        printOut("All shops length ${allShops.length}");

        update();
      } catch (e) {
        printOut(e);
        isSearchingShop.value = false;
      }
    } else {}
  }
}
