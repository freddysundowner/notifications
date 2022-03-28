import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/orders_model.dart';
import 'package:fluttergistshop/screens/profile/settings/individual_order.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/functions.dart';
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
            ? _userController.userOrders.isNotEmpty
                ? ListView.builder(
                    itemCount: _userController.userOrders.length,
                    itemBuilder: (context, index) {
                      print(
                          "_userController.userOrders ${_userController.userOrders}");
                      OrdersModel ordersModel = OrdersModel.fromJson(
                          _userController.userOrders.elementAt(index));
                      return InkWell(
                        onTap: () {
                          Get.to(IndividualOrderScreen(ordersModel));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, bottom: 20),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    convertTime(ordersModel.date.toString()),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.sp),
                                  )),
                              SizedBox(
                                height: 0.01.sh,
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child:
                                            CachedNetworkImage(
                                              imageUrl: ordersModel.itemId!.productId!
                                                  .images!.first,
                                              height: 0.1.sh,
                                              width: 0.2.sw,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) => Image.asset("assets/icons/no_image.png"),
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0.02.sw,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              ordersModel
                                                  .itemId!.productId!.name!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp),
                                            )),
                                        Row(
                                          children: [
                                            Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp),
                                            ),
                                            Text(
                                              ordersModel.status!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Quantity: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp),
                                            ),
                                            Text(
                                              ordersModel.itemId!.quantity
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Total: $gccurrency ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp),
                                            ),
                                            Text(
                                              ordersModel.totalCost.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text(
                      "You have no orders yet",
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    ),
                  )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
      }),
    );
  }
}
