import 'package:flutter/material.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CheckOutController extends GetxController {
  Rxn<Product> product = Rxn();
  Rxn<Order> order = Rxn();
  // RxList<List<Checkout>> checkout = RxList();
  Rxn<Address> address = Rxn();
  RxInt qty = 0.obs;
  RxInt selectetedvariation = 0.obs;
  RxString selectetedvariationvalue = "".obs;
  RxInt ordertotal = 0.obs;
  RxInt shipping = 0.obs;
  var msg = "".obs;
  RxInt tax = 0.obs;


  final TextEditingController addressReceiverFieldController = TextEditingController();

  final TextEditingController addressLine1FieldController =
  TextEditingController();

  final TextEditingController addressLine2FieldController =
  TextEditingController();

  final TextEditingController cityFieldController = TextEditingController();

  final TextEditingController stateFieldController = TextEditingController();

  final TextEditingController phoneFieldController = TextEditingController();
}
