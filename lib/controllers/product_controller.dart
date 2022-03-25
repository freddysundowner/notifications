import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/services/client.dart';
import 'package:fluttergistshop/services/configs.dart' as config;
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

enum ImageType {
  local,
  network,
}

class CustomImage {
  final ImageType imgType;
  final String path;
  CustomImage({this.imgType = ImageType.local, required this.path});
  @override
  String toString() {
    return "Instance of Custom Image: {imgType: $imgType, path: $path}";
  }
}

class ProductController extends GetxController {
  Rxn<Product> productObservable = Rxn();
  static Rxn<List<Product>> _products = Rxn([]);

  RxInt selectedPage = 0.obs;
  var error = "".obs;
  Product get product => productObservable.value!;
  set product(Product value) => productObservable.value = value;

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

  var selectedImages = [].obs;
  var _selectedImages = [].obs;

  set initialSelectedImages(List<CustomImage> images) {
    _selectedImages.value = images;
  }

  void setSelectedImageAtIndex(CustomImage image, int index) {
    if (index < selectedImages.value.length) {
      selectedImages.value[index] = image;
    }
  }

  void addNewSelectedImage(CustomImage image) {
    print("addNewSelectedImage ${image.path}");
    _selectedImages.add(image);
    print("addNewSelectedImage length ${_selectedImages.length}");
  }

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
      print("updateProduct $productdata");
      return DbBase().databaseRequest(
          config.updateproduct + productid, DbBase().patchRequestType,
          body: productdata);
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  static Future<List<Product>> getProductsByShop(String id) async {

    List<dynamic> response = await ShopApi.getProductsByShop(id);
    _products.value = response.map((e) => Product.fromJson(e)).toList();
    printOut("after ${_products.value!.length}");

    return response.map((e) => Product.fromJson(e)).toList();
  }
}
