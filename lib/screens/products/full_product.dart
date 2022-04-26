import 'package:cached_network_image/cached_network_image.dart';
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

import '../../controllers/shop_controller.dart';
import '../../utils/utils.dart';
import '../shops/shop_view.dart';

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
    Get.find<ProductController>().getProductById(product);
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
                          Text(
                            "Product by:",
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.find<ShopController>()
                                  .currentShop
                                  .value =
                              productController.currentProduct.value!
                                  .shopId!;
                              Get.to(() => ShopView());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Center(
                                    child: productController.currentProduct.value!
                                                    .shopId!.image !=
                                                null &&
                                            productController.currentProduct
                                                    .value!.shopId!.name !=
                                                ""
                                        ? CachedNetworkImage(
                                            imageUrl: productController
                                                .currentProduct
                                                .value!
                                                .shopId!
                                                .image!,
                                            height: 0.08.sh,
                                            width: 0.15.sw,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) =>
                                                const Icon(Icons.error),
                                          )
                                        : Image.asset(
                                            "assets/icons/no_image.png",
                                            height: 0.08.sh,
                                            width: 0.15.sw,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  SizedBox(
                                    width: 0.03.sw,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productController.currentProduct.value!.shopId!.name!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                        ),
                                        Text(
                                          productController.currentProduct.value!
                                              .shopId!.description!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                    backgroundColor: sc_snackBar,
                                    messageText: Text(
                                      _snackBarMessage,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
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
