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

  final _snackBarMessage = "Product added to the cart";

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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name!,
                      style: boldHeading,
                    ),
                    Text(
                      product.htmlPrice(product.price).toString(),
                      style: TextStyle(
                        fontSize: 18.0.sp,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      product.description.toString(),
                      style: TextStyle(
                        fontSize: 15.0.sp,
                      ),
                    ),
                    if (product.variations!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Variation",
                            style: regularDarkText,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ProductSize(
                            productSizes: product.variations!,
                            onSelected: (size) {
                              printOut(size);
                              checkOutController
                                  .selectetedvariationvalue.value = size;
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    product.ownerId!.id !=
                            FirebaseAuth.instance.currentUser!.uid
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _addToSaved();
                                  GetSnackBar(
                                    message: _snackBarMessage,
                                  );
                                },
                                child: Container(
                                  width: 0.15.sw,
                                  height: 0.08.sh,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCDCDC),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: const AssetImage(
                                      "assets/images/tab_saved.png",
                                    ),
                                    height: 0.035.sh,
                                  ),
                                ),
                              ),
                              product.shopId!.open!
                                  ? Expanded(
                                      child: GestureDetector(
                                        onTap: product.quantity! < 1
                                            ? null
                                            : () {
                                                checkOutController
                                                    .product.value = product;
                                                checkOutController.qty.value =
                                                    1;
                                                printOut(
                                                    "b ${checkOutController.selectetedvariationvalue.value}");
                                                if (checkOutController
                                                            .selectetedvariationvalue
                                                            .value ==
                                                        "" &&
                                                    product.variations!
                                                        .isNotEmpty) {
                                                  checkOutController
                                                          .selectetedvariationvalue
                                                          .value =
                                                      product.variations![0];
                                                }
                                                Get.to(() => CheckOut());
                                              },
                                        child: Container(
                                          height: 0.08.sh,
                                          margin: const EdgeInsets.only(
                                            left: 16.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: product.quantity! < 1
                                                ? Colors.grey
                                                : primarycolor,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            product.quantity! < 1
                                                ? "Out of Stock"
                                                : "Buy Now",
                                            style: TextStyle(
                                                fontSize: 18.0.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        : Container()
                  ],
                ),
              )
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
