import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/cart/cart_screen.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class MyProducts extends StatelessWidget {
  CheckOutController checkOutController = Get.find<CheckOutController>();
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
          physics: AlwaysScrollableScrollPhysics(),
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
                      style: TextStyle(fontSize: 12),
                    ),
                  if (edit == false)
                    Text(
                      "Swipe LEFT to Buy, Swipe RIGHT to Favorite",
                      style: TextStyle(fontSize: 12),
                    ),
                  SizedBox(height: 20.h),
                  Column(
                    children: Get.find<ProductController>()
                        .products
                        .map((e) => buildProductDismissible(e, context))
                        .toList(),
                  ),
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
      background: buildDismissibleSecondaryBackground(),
      secondaryBackground: buildDismissiblePrimaryBackground(),
      dismissThresholds: {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: ShopShortDetailCard(
        product: product,
        onPressed: () {},
      ),
      confirmDismiss: (direction) async {
        if (edit) {
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
            if (confirmation) {}
            await refreshPage();
            return false;
          }
        } else {
          if (direction == DismissDirection.startToEnd) {
            final confirmation = await showConfirmationDialog(
                context, "Continue to buying this product?");
            checkOutController.product.value = product;
            checkOutController.qty.value = 1;
            Get.to(() => CartScreen());

            return false;
          } else if (direction == DismissDirection.endToStart) {
            final confirmation =
                await showConfirmationDialog(context, "Add to favorite");
            Helper.showSnackBack(context, "Added to favorite");
            if (confirmation) {}
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

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: edit
          ? Row(
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
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: edit ? Colors.red : primarycolor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: edit
          ? Row(
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
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
            ),
    );
  }
}
