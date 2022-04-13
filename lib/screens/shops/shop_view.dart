import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/edit_product/edit_product_screen.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/shops/add_edit_shop.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class ShopView extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  ProductController productController = Get.find<ProductController>();
  ShopView();
  String closeShopIcon = "assets/icons/close_shop.png";
  String openShopIcon = "assets/icons/open_shop.png";
  String shopClosedIcon = "assets/icons/shop_closed.png";

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Obx(() {
            return Container(
              child: shopController.currentShop.value.id ==
                      authController.currentuser!.shopId!.id
                  ? InkWell(
                      onTap: () async {
                        await openOrCloseShop(context);
                      },
                      child: Image.asset(
                        shopController.currentShop.value.open == true
                            ? closeShopIcon
                            : openShopIcon,
                        color: Colors.black,
                        height: 0.01.sh,
                        width: 0.1.sw,
                      ),
                    )
                  : Container(),
            );
          }),
          SizedBox(
            width: 0.03.sw,
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Obx(() {
                  return Row(
                    children: [
                      shopController.currentShop.value.image != null
                          ? CachedNetworkImage(
                              imageUrl: shopController.currentShop.value.image!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 0.25.sw,
                                height: 0.14.sh,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/icons/no_image.png",
                                  width: 0.25.sw,
                                  height: 0.14.sh),
                            )
                          : CircleAvatar(
                              radius: 50,
                              child: Image.asset("assets/icons/no_image.png",
                                  width: 0.25.sw, height: 0.14.sh),
                            ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shopController.currentShop.value.name!,
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.black),
                            ),
                            Text(
                              shopController.currentShop.value.email!,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      if (authController.currentuser!.shopId != null &&
                          shopController.currentShop.value.id ==
                              authController.currentuser!.shopId?.id)
                        InkWell(
                          onTap: () {
                            Get.to(() => NewShop());
                          },
                          child: Icon(
                            Icons.edit,
                            color: primarycolor,
                            size: 30.sm,
                          ),
                        ),
                    ],
                  );
                }),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "${shopController.currentShop.value.description}",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
                SizedBox(
                  height: 5.h,
                ),
                if (shopController.currentShop.value.open == true)
                  const Divider(
                    color: primarycolor,
                  ),
                if (shopController.currentShop.value.open == true)
                  Text("Products", style: headingStyle),
              ],
            ),
            Expanded(
                child: GetX<ProductController>(initState: (_) async {
              if (shopController.currentShop.value.id ==
                  authController.currentuser!.shopId?.id) {
                Get.find<ProductController>().products =
                    await ProductController.getMyProductsByShop(
                        shopController.currentShop.value.id!);
              } else {
                Get.find<ProductController>().products =
                    await ProductController.getProductsByShop(
                        shopController.currentShop.value.id!);
              }
            }, builder: (_) {
              if (ProductController.loading.value == true) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // if (shopController.currentShop.value.open == false) {
              //   return SizedBox(
              //     height: MediaQuery.of(context).size.height * 0.5,
              //     child: Center(
              //       child: Text(
              //         "Your shop is closed, please open it too view your products",
              //         style: TextStyle(fontSize: 16),
              //       ),
              //     ),
              //   );
              // }
              return _.products.isNotEmpty && shopController.currentShop.value.open!
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _.products.length,
                      itemBuilder: (context, index) {
                        return authController.currentuser!.shopId != null &&
                                authController.currentuser!.shopId != null &&
                                shopController.currentShop.value.id ==
                                    authController.currentuser!.shopId!.id
                            ? buildProductDismissible(
                                _.products[index], context)
                            : ShopShortDetailCard(
                                product: _.products[index],
                                onPressed: () {
                                  printOut("v ${_.products[index].shopId!.id}");
                                  Get.to(() =>
                                      FullProduct(product: _.products[index]));
                                },
                              );
                      })
                  : const Text("No Products yet");
              // return Column(
              //   children: _.products.map((e) => Text(e.name)).toList(),
              // );
            }))
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        return authController.currentuser!.shopId != null &&
                shopController.currentShop.value.id ==
                    authController.currentuser!.shopId!.id
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                elevation: 4,
                hoverColor: Colors.green,
                splashColor: Colors.green,
                onPressed: () {
                  printOut("EditProductScreen");
                  Get.to(() => EditProductScreen());
                },
                backgroundColor: Colors.pink,
              )
            : Container();
      }),
    );
  }

  Future<void> openOrCloseShop(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(authController.usermodel.value!.shopId!.open == true
              ? "Are you sure you want to close your shop? All your products will be disabled"
              : "Are you sure you want to open your shop?"),
          actions: [
            FlatButton(
              child: Text("Yes"),
              onPressed: () async {
                authController.usermodel.value!.shopId!.open =
                    !authController.usermodel.value!.shopId!.open!;
                authController.usermodel.refresh();

                var response = ShopApi.updateShop(
                    {"open": authController.usermodel.value!.shopId!.open},
                    shopController.currentShop.value.id!);
                try {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AsyncProgressDialog(
                        response,
                        message: Text(
                            authController.usermodel.value!.shopId!.open ==
                                    false
                                ? "Closing shop"
                                : "Opening the shop"),
                        onError: (e) {},
                      );
                    },
                  );
                } finally {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          authController.usermodel.value!.shopId!.open == false
                              ? "Shop closed successfully"
                              : "Shop opened successfully", style: TextStyle(color: Colors.white),),
                      backgroundColor: sc_snackBar,
                    ),
                  );
                  Navigator.pop(context, false);
                  await ProductController.getProductsByShop(
                      shopController.currentShop.value.id!);
                }
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildProductDismissible(Product product, BuildContext context) {
    return Dismissible(
      key: Key(product.id.toString()),
      direction: DismissDirection.horizontal,
      background: buildDismissibleSecondaryBackground(),
      secondaryBackground: buildDismissiblePrimaryBackground(),
      dismissThresholds: const {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: ShopShortDetailCard(
        product: product,
        onPressed: () {
          Get.to(() => FullProduct(product: product));
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
              context, "Are you sure you want to Delete Product?");
          if (confirmation) {
            for (int i = 0; i < product.images!.length; i++) {}

            bool productInfoDeleted = false;

            var deleteProduct =
                await ProductPI.updateProduct({"deleted": true}, product.id!);
            productInfoDeleted = deleteProduct["success"];
            String snackbarMessage = "";
            try {
              if (productInfoDeleted == true) {
                snackbarMessage = "Product deleted successfully";
              } else {
                throw "Couldn't delete product, please retry";
              }
            } catch (e) {
              snackbarMessage = e.toString();
            } finally {
              GetSnackBar(
                messageText: Text(snackbarMessage, style: const TextStyle(color: Colors.white),),
                backgroundColor: sc_snackBar,
              );
            }
          }
          await refreshPage();
          return confirmation;
        } else if (direction == DismissDirection.endToStart) {
          final confirmation = await showConfirmationDialog(
              context, "Are you sure to Edit Product?");
          if (confirmation) {
            productController.product = product;
            productController.selectedImages.assignAll(productController
                .product.images!
                .map((e) => CustomImage(imgType: ImageType.network, path: e))
                .toList());

            Get.to(() => EditProductScreen(
                  product: product,
                ));
          }
          await refreshPage();
          return false;
        }
        return false;
      },
      onDismissed: (direction) async {
        await refreshPage();
      },
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
