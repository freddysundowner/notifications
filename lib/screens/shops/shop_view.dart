import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/edit_product/edit_product_screen.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/shops/add_edit_shop.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class ShopView extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  ProductController productController = Get.find<ProductController>();
  ShopId currentShop;
  ShopView(this.currentShop);

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                          image: currentShop.image != ""
                              ? DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(imageUrl + currentShop.image))
                              : const DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/icons/no_image.png"))
                      )),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentShop.name,
                          style:
                              TextStyle(fontSize: 13.sp, color: Colors.black),
                        ),
                        Text(
                          currentShop.email,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  if (currentShop.id == authController.currentuser!.shopId!.id)
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
                currentShop.description,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              SizedBox(
                height: 5.h,
              ),
              const Divider(
                color: primarycolor,
              ),
              Text("Products", style: headingStyle),
              GetX<ProductController>(
                  initState: (_) async =>
                      Get.find<ProductController>().products =
                          await ProductController.getProductsByShop(
                              currentShop.id),
                  builder: (_) {
                    if (_.products.isEmpty) {
                      return Text("No Products yet");
                    }
                    if (_.products.length > 0) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            itemCount: _.products.length,
                            itemBuilder: (context, index) {
                              return currentShop.id == authController.currentuser!.shopId!.id ? buildProductDismissible(
                                  _.products[index], context) : ShopShortDetailCard(
                                product: _.products[index],
                                onPressed: () {
                                  print("v");
                                  Get.to(() => FullProduct(product: _.products[index]));
                                },
                              );
                            }),
                      );
                      // return Column(
                      //   children: _.products.map((e) => Text(e.name)).toList(),
                      // );
                    }
                    return Text("No Products yet");
                  })

            ],
          ),
        ),
      ),

      floatingActionButton: currentShop.id == authController.currentuser!.shopId!.id ? FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 4,
        hoverColor: Colors.green,
        splashColor: Colors.green,
        onPressed: () {
          // if (productController.product != null) {
          //   productController.product.id = null;
          // }

          print("EditProductScreen");
          Get.to(() => EditProductScreen(
                product: productController.product,
              ));
        },
        backgroundColor: Colors.pink,
      ) : Container(),
    );
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
              context, "Are you sure to Delete Product?");
          if (confirmation) {
            for (int i = 0; i < product.images!.length; i++) {}

            bool productInfoDeleted = false;
            String snackbarMessage;
            try {
              if (productInfoDeleted == true) {
                snackbarMessage = "Product deleted successfully";
              } else {
                throw "Coulnd't delete product, please retry";
              }
            } catch (e) {
              snackbarMessage = e.toString();
            } finally {}
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
