import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/controllers/favorite_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/cart/checkout_screen.dart';
import 'package:fluttergistshop/screens/products/components/custom_action_bar.dart';
import 'package:fluttergistshop/screens/products/components/product_size.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class FullProduct extends StatelessWidget {
  Product product;
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductController productController = Get.find<ProductController>();
  FullProduct({Key? key, required this.product}) : super(key: key);

  _addToSaved(BuildContext context) async {
    var response;
    var adding = false;
    if (Get.find<FavoriteController>()
            .products
            .value
            .indexWhere((element) => element.id == product.id) !=
        -1) {
      adding = false;
      response = Get.find<FavoriteController>().deleteFavorite(product.id!);
    } else {
      adding = true;
      response = Get.find<FavoriteController>().saveFavorite(product.id!);
    }
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          response,
          message:
              Text(adding == false ? "removing favorite" : "adding favorite"),
          onError: (e) {},
        );
      },
    );
  }

  final _snackBarMessage = "Product added to the cart";

  @override
  Widget build(BuildContext context) {
    Get.find<ProductController>().getProductById(product.id!);
    if (productController.currentProduct.value == null) {
      productController.currentProduct.value = product;
    }

    return Scaffold(
        body: Obx(
      () => Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              ImageSwipe(
                imageList: productController.currentProduct.value!.images!,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productController.currentProduct.value!.name!,
                      style: boldHeading,
                    ),
                    Text(
                      productController.currentProduct.value!
                          .htmlPrice(
                              productController.currentProduct.value!.price)
                          .toString(),
                      style: TextStyle(
                        fontSize: 18.0.sp,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      productController.currentProduct.value!.description
                          .toString(),
                      style: TextStyle(
                        fontSize: 15.0.sp,
                      ),
                    ),
                    if (productController
                        .currentProduct.value!.variations!.isNotEmpty)
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
                            productSizes: productController
                                .currentProduct.value!.variations!,
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
                    productController.currentProduct.value!.ownerId!.id !=
                            FirebaseAuth.instance.currentUser!.uid
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _addToSaved(context);
                                  GetSnackBar(
                                    message: _snackBarMessage,
                                  );
                                },
                                child: Container(
                                  width: 0.15.sw,
                                  height: 0.08.sh,
                                  decoration: BoxDecoration(
                                    color: Get.find<FavoriteController>()
                                                .products
                                                .indexWhere((element) =>
                                                    element.id == product.id) !=
                                            -1
                                        ? Colors.red
                                        : const Color(0xFFDCDCDC),
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: productController.currentProduct.value!
                                                  .quantity! <
                                              1 ||
                                          productController.currentProduct
                                                  .value!.shopId!.open ==
                                              false
                                      ? null
                                      : () {
                                          checkOutController.product.value =
                                              product;
                                          checkOutController.qty.value = 1;
                                          if (checkOutController
                                                      .selectetedvariationvalue
                                                      .value ==
                                                  "" &&
                                              product.variations!.isNotEmpty) {
                                            checkOutController
                                                .selectetedvariationvalue
                                                .value = product.variations![0];
                                          }
                                          Get.to(() => CheckOut());
                                        },
                                  child: Container(
                                    height: 0.08.sh,
                                    margin: const EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: productController.currentProduct
                                                  .value!.quantity! <
                                              1
                                          ? Colors.grey
                                          : primarycolor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      productController.currentProduct.value!
                                                  .quantity! <
                                              1
                                          ? "Out of Stock"
                                          : productController.currentProduct
                                                      .value!.shopId!.open ==
                                                  true
                                              ? "Buy Now"
                                              : "Not Available",
                                      style: TextStyle(
                                          fontSize: 18.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              )
            ],
          ),
          CustomActionBar(
            title: productController.currentProduct.value!.name!,
            qty: productController.currentProduct.value!.quantity.toString(),
          )
        ],
      ),
    ));
  }
}
