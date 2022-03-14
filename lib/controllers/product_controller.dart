import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/services/api_calls.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductController extends GetxController {
  Rxn<Product> _product = Rxn();
  get product => _product.value;

  final TextEditingController qtyFieldController = TextEditingController();
  final TextEditingController titleFieldController = TextEditingController();
  final TextEditingController discountPriceFieldController =
      TextEditingController();
  final TextEditingController originalPriceFieldController =
      TextEditingController();
  final TextEditingController variantFieldController = TextEditingController();
  final TextEditingController sellerFieldController = TextEditingController();
  final TextEditingController highlightsFieldController =
      TextEditingController();
  final TextEditingController desciptionFieldController =
      TextEditingController();

  saveProduct() {
    try {
      Map<String, dynamic> productdata = new Product(
          name: titleFieldController.text,
          price: int.parse(originalPriceFieldController.text),
          quantity: int.parse(qtyFieldController.text),
          shopId: Get.find<AuthController>().currentuser!.shopId,
          ownerId: FirebaseAuth.instance.currentUser!.uid,
          images: []).toJson();
      var response = ApiCalls.saveProduct(productdata);
    } catch (e) {}
  }
}
