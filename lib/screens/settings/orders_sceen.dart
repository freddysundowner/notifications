import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/screens/settings/shop_orders.dart';
import 'package:fluttergistshop/screens/settings/user_orders.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        appBar: AppBar(
          backgroundColor: const Color(0xfff5f5f5),
              title: const Text(
                "Orders",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: false,
          bottom: const TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(icon: Icon(Icons.person, color: Colors.black,),text: "Your orders",),
              Tab(icon: Icon(Icons.shopping_basket_rounded, color: Colors.black,), text: "Shop Orders",),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserOrders(),
            ShopOrders(),
          ],
        ),
      ),

    );
  }
}
