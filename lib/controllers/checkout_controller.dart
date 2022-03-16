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
  RxInt tax = 0.obs;
}
