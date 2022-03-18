import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/orders_model.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f5f5),
        title: const Text(
          "Orders",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        return _userController.ordersLoading.isFalse
            ? ListView.builder(
                itemCount: _userController.userOrders.length,
                itemBuilder: (context, index) {
                  OrdersModel ordersModel = OrdersModel.fromJson(_userController.userOrders.elementAt(index));
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "12/03/2022",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.sp),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ordersModel.id!,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.sp),
                              )),
                          Row(
                            children: [
                              Text(
                                "Status: ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                              ),
                              Text(
                                ordersModel.status!,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Total: ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                              ),
                              Text(
                                ordersModel.totalCost.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
      }),
    );
  }
}
