import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/cart/checkout_screen.dart';
import 'package:fluttergistshop/screens/products/components/custom_action_bar.dart';
import 'package:fluttergistshop/screens/products/components/product_size.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class FullProduct extends StatelessWidget {
  final Product product;
  CheckOutController checkOutController = Get.find<CheckOutController>();
  FullProduct({Key? key, required this.product}) : super(key: key);

  _addToSaved() {}

  final  _snackBarMessage = "Product added to the cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              ImageSwipe(
                imageList: product.images!,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 24.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 4.0,
                ),
                child: Text(
                  product.name!,
                  style: boldHeading,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 24.0,
                ),
                child: Text(
                  product.htmlPrice(product.price).toString(),
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 24.0,
                ),
                child: Text(
                  product.description.toString(),
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),
              ),
              if (product.variations!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Variation",
                        style: regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: product.variations!,
                      onSelected: (size) {
                        printOut(size);
                        checkOutController.selectetedvariationvalue.value =
                            size;
                      },
                    ),
                  ],
                ),
              product.ownerId!.id != FirebaseAuth.instance.currentUser!.uid ?
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _addToSaved();
                        GetSnackBar(message: _snackBarMessage,);
                      },
                      child: Container(
                        width: 50.0.w,
                        height: 50.0.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCDCDC),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.center,
                        child: Image(
                          image: const AssetImage(
                            "assets/images/tab_saved.png",
                          ),
                          height: 22.0.h,
                        ),
                      ),
                    ),

                    product.shopId!.open! ? Expanded(
                      child: GestureDetector(
                        onTap: () {
                          checkOutController.product.value = product;
                          checkOutController.qty.value = 1;
                          printOut(
                              "b ${checkOutController.selectetedvariationvalue.value}");
                          if (checkOutController
                                      .selectetedvariationvalue.value ==
                                  "" &&
                              product.variations!.isNotEmpty) {
                            checkOutController.selectetedvariationvalue.value =
                                product.variations![0];
                          }
                          Get.to(() => CheckOut());
                        },
                        child: Container(
                          height: 50.0.h,
                          margin: const EdgeInsets.only(
                            left: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: primarycolor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Buy Now",
                            style: TextStyle(
                                fontSize: 18.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ) : Container()
                  ],
                ),
              ) : Container()
            ],
          ),
          CustomActionBar(
            title: product.name!,
            qty: product.quantity.toString(),
          )
        ],
      ),
    );
  }
}
