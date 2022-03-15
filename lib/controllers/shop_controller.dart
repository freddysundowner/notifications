import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/shop.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ShopController extends GetxController {
  Rxn<Shop> _shop = Rxn();
  get shop => _shop.value;
  RxString error = "".obs;

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
        Get.back();
      } else {
        error.value = response["message"];
      }
      return response;
    } catch (e) {}
  }

  updateShop(String id) async {
    try {
      Map<String, dynamic> productdata = new Shop(
              name: nameController.text,
              phoneNumber: mobileController.text,
              description: descriptionController.text,
              location: daddressController.text,
              email: emailController.text)
          .toJson();
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
}
