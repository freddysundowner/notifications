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
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/shop_api.dart';
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
              child: shopController.currentShop.value.id == authController.currentuser!.shopId!.id
                  ? InkWell(
                      onTap: () async {
                        await openOrCloseShop();
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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: shopController.currentShop.value.image != ""
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                      imageUrl + shopController.currentShop.value.image!))
                              : const DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      "assets/icons/no_image.png")))),
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
                          style:
                              TextStyle(fontSize: 13.sp, color: Colors.black),
                        ),
                        Text(
                          shopController.currentShop.value.email!,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  if (shopController.currentShop.value.id == authController.currentuser!.shopId!.id)
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
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                shopController.currentShop.value.description!,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              SizedBox(
                height: 5.h,
              ),
              const Divider(
                color: primarycolor,
              ),
              Text("Products", style: headingStyle),
              Stack(
                children: [
                  GetX<ProductController>(
                      initState: (_) async {
                          Get.find<ProductController>().products =
                              await ProductController.getProductsByShop(
                                  shopController.currentShop.value.id!); },
                      builder: (_) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: _.products.isNotEmpty ? ListView.builder(
                                itemCount: _.products.length,
                                itemBuilder: (context, index) {
                                  return shopController.currentShop.value.id ==
                                          authController.currentuser!.shopId!.id
                                      ? buildProductDismissible(
                                          _.products[index], context)
                                      : ShopShortDetailCard(
                                          product: _.products[index],
                                          onPressed: () {
                                            printOut("v");
                                              Get.to(() => FullProduct(
                                                  product: _.products[index]));

                                          },
                                        );
                                }) : const Text("No Products yet"),
                          );
                          // return Column(
                          //   children: _.products.map((e) => Text(e.name)).toList(),
                          // );

                      }),
                  if (shopController.currentShop.value.id != authController.currentuser!.shopId!.id)
                    Obx(() {
                      return shopController.currentShop.value.open == false
                          ? Center(
                              child: Image.asset(
                              shopClosedIcon,
                              color: Colors.red,
                              height: 0.3.sh,
                              width: 0.6.sw,
                            ))
                          : Container();
                    })
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton:
      shopController.currentShop.value.id == authController.currentuser!.shopId!.id
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  elevation: 4,
                  hoverColor: Colors.green,
                  splashColor: Colors.green,
                  onPressed: () {
                    // if (productController.product != null) {
                    //   productController.product.id = null;
                    // }

                    print("EditProductScreen");
                    Get.to(() => EditProductScreen(
                          product: productController.productObservable.value,
                        ));
                  },
                  backgroundColor: Colors.pink,
                )
              : Container(),
    );
  }

  Future<void> openOrCloseShop() async {
    authController.usermodel.value!.shopId!.open =
        !authController.usermodel.value!.shopId!.open!;
    authController.usermodel.refresh();

    await ShopApi.updateShop(
        {"open": authController.usermodel.value!.shopId!.open},
        shopController.currentShop.value.id!);
  }

  Widget buildProductDismissible(Product product, BuildContext context) {
    return Dismissible(
      key: Key(product.id.toString()),
      direction: DismissDirection.horizontal,
      background: buildDismissibleSecondaryBackground(),
      secondaryBackground: buildDismissiblePrimaryBackground(),
      dismissThresholds: {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: ShopShortDetailCard(
        product: product,
        onPressed: () {
          print("v");
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

            var deleteProduct = await ProductPI.updateProduct(
                {"available": false}, product.id!);
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
                message: snackbarMessage,
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
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
