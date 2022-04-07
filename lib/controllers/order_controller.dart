import 'package:fluttergistshop/models/orders_model.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';


class OrderController extends GetxController {
  var currentOrder = OrdersModel().obs;

}