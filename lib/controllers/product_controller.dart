import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductController extends GetxController {
  Rxn<Product> _product = Rxn();
  static Rxn<List<Product>> _products = Rxn([]);

  var error = "".obs;
  Product get product => _product.value!;
  set product(Product value) => _product.value = value;

  List<Product> get products => _products.value!;
  set products(List<Product> value) => _products.value = value;

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

  @override
  void onInit() {
    super.onInit();
  }

  saveProduct() {
    try {
      Map<String, dynamic> productdata = {
        "name": titleFieldController.text,
        "price": originalPriceFieldController.text,
        "quantity": qtyFieldController.text,
        "description": desciptionFieldController.text,
        "shopId": Get.find<AuthController>().currentuser!.shopId!.id,
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "variations": variantFieldController.text
      };

      return ProductPI.saveProduct(productdata);
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  updateProduct(String productid) {
    try {
      Map<String, dynamic> productdata = {
        "name": titleFieldController.text,
        "price": originalPriceFieldController.text,
        "quantity": qtyFieldController.text,
        "description": desciptionFieldController.text,
        "variations": variantFieldController.text
      };

      return ProductPI.updateProduct(productdata, productid);
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  static Future<List<Product>> getProductsByShop(String id) async {
    List<dynamic> response = await ShopApi.getProductsByShop(id);
    _products.value = response.map((e) => Product.fromJson(e)).toList();
    print("after ${_products.value!.length}");
    return response.map((e) => Product.fromJson(e)).toList();
  }
}
