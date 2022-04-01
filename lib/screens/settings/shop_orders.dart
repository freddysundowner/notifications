import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/orders_model.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'individual_order.dart';

class ShopOrders extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  ShopOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _userController.getShopOrders();
    return Obx(() {
      return _userController.ordersLoading.isFalse
          ? _userController.shopOrders.isNotEmpty
          ? ListView.builder(
          itemCount: _userController.shopOrders.length,
          itemBuilder: (context, index) {
            print(
                "_userController.shopOrders ${_userController.shopOrders}");
            OrdersModel ordersModel = OrdersModel.fromJson(
                _userController.shopOrders.elementAt(index));
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
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: ordersModel.itemId!.productId!
                                      .images!.isNotEmpty
                                      ? CachedNetworkImage(
                                    imageUrl: ordersModel.itemId!
                                        .productId!.images!.first,
                                    height: 0.1.sh,
                                    width: 0.2.sw,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                    errorWidget: (context, url,
                                        error) =>
                                        Image.asset(
                                            "assets/icons/no_image.png"),
                                  )
                                      : Image.asset(
                                    "assets/icons/no_image.png",
                                    height: 0.1.sh,
                                    width: 0.2.sw,
                                    fit: BoxFit.fill,
                                  )),
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
    });
  }
}
