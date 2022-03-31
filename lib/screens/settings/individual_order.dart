import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/orders_model.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/functions.dart';

class IndividualOrderScreen extends StatelessWidget {
  OrdersModel ordersModel;

  IndividualOrderScreen(this.ordersModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Status: ",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                      Text(
                        ordersModel.status!,
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "OrderId: ",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                      Text(
                        ordersModel.id.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Date: ",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                      Text(
                        convertTime(ordersModel.date.toString()),
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.04.sh,
            ),
            const Divider(
              color: Colors.black12,
              thickness: 10,
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Text(
                "Delivery information",
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Name: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Text(
                        "${ordersModel.shippingId!.name}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Text(
                        "${ordersModel.shippingId!.phone}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Address 1: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Text(
                        "${ordersModel.shippingId!.addrress1}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Address 2: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Text(
                        "${ordersModel.shippingId!.addrress2}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "City: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Text(
                        "${ordersModel.shippingId!.city}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "State: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Text(
                        "${ordersModel.shippingId!.state}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            const Divider(
              color: Colors.black12,
              thickness: 10,
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Text(
                "Product information",
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ordersModel
                                  .itemId!.productId!.images!.isNotEmpty
                              ? Image.network(
                                  ordersModel.itemId!.productId!.images!.first,
                                  height: 0.1.sh,
                                  width: 0.2.sw,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  "assets/icons/no_image.png",
                                  height: 0.1.sh,
                                  width: 0.2.sw,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ordersModel.itemId!.productId!.name!,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                          ),
                          Text(
                            "$gccurrency ${(ordersModel.totalCost! / ordersModel.itemId!.quantity!)} x ${ordersModel.itemId!.quantity}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            const Divider(
              color: Colors.black12,
              thickness: 10,
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order summary ",
                    style: TextStyle(color: Colors.black, fontSize: 18.sp),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      Text(
                        "x ${ordersModel.itemId!.quantity}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      Text(
                        "$gccurrency ${ordersModel.totalCost! - ordersModel.shippingFee!}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shipping: ",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                      Text(
                        "$gccurrency ${ordersModel.shippingFee}",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order total: ",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                      Text(
                        "$gccurrency ${ordersModel.totalCost}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.03.sh,
            ),
          ],
        ),
      ),
    );
  }
}
