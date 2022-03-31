import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/cart/checkout_screen.dart';
import 'package:fluttergistshop/screens/edit_product/edit_product_screen.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/services/product_api.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import 'full_product.dart';

class MyProducts extends StatelessWidget {
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductController productController = Get.find<ProductController>();
  final String title;
  final bool edit;
  MyProducts({Key? key, required this.title, required this.edit})
      : super(key: key);

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.3.sm),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(title, style: headingStyle),
                  if (edit)
                    Text(
                      "Swipe LEFT to Edit, Swipe RIGHT to Delete",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  if (edit == false)
                    Text(
                      "Swipe LEFT to Buy, Swipe RIGHT to Favorite",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  SizedBox(height: 0.02.sh),
                  Column(
                    children: Get.find<ProductController>()
                        .products
                        .map((e) => buildProductDismissible(e, context))
                        .toList(),
                  ),
                  SizedBox(height: 0.02.sh),
                ],
              ),
            ),
          ),
        ),
      ),
      //body: Body(),
    );
  }

  Widget buildProductDismissible(Product product, BuildContext context) {
    return Dismissible(
      key: Key(product.id.toString()),
      direction: DismissDirection.horizontal,
      background: buildDismissibleSecondaryBackground(product),
      secondaryBackground: buildDismissiblePrimaryBackground(product),
      dismissThresholds: const {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: ShopShortDetailCard(
        product: product,
        onPressed: () {
          Get.to(FullProduct(
            product: product,
          ));
        },
      ),
      confirmDismiss: (direction) async {
        if (edit) {
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
        } else {
          if (direction == DismissDirection.startToEnd) {
            final confirmation = await showConfirmationDialog(
                context, "Continue to buying this product?");
            checkOutController.product.value = product;
            checkOutController.qty.value = 1;

            if (confirmation) {
              Get.to(() => CheckOut());
            }

            return false;
          } else if (direction == DismissDirection.endToStart) {
            final confirmation =
                await showConfirmationDialog(context, "Add to favorite");
            await UserAPI.addFavorite(product.id!);
            if (confirmation) {
              Helper.showSnackBack(context, "Added to favorite");
            }
            return false;
          }
        }
        return false;
      },
      onDismissed: (direction) async {
        await refreshPage();
      },
    );
  }

  Widget buildDismissiblePrimaryBackground(Product product) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: edit
          ? Row(
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
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text(
                  "Favorite",
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

  Widget buildDismissibleSecondaryBackground(Product product) {
    return Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: edit ? Colors.red : primarycolor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: edit
            ? Row(
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
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Buy",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                ],
              ));
  }
}
