import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/shop.dart';
import 'package:fluttergistshop/services/api_calls.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ShopController extends GetxController {
  Rxn<Shop> _shop = Rxn();
  get shop => _shop.value;

  TextEditingController nameController = TextEditingController(),
      mobileController = TextEditingController(),
      descriptionController = TextEditingController(),
      daddressController = TextEditingController(),
      emailController = TextEditingController();

  saveProduct() {
    try {
      Map<String, dynamic> productdata = new Shop(
              name: nameController.text,
              phoneNumber: mobileController.text,
              description: descriptionController.text,
              location: daddressController.text,
              open: true,
              email: emailController.text)
          .toJson();
      var response = ApiCalls.saveShop(productdata);
    } catch (e) {}
  }
}
