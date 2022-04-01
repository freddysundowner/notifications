import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/controllers/favorite_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/cart/checkout_screen.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class Favorites extends StatelessWidget {
  CheckOutController checkOutController = Get.find<CheckOutController>();
  FavoriteController productController = Get.find<FavoriteController>();
  Favorites({Key? key}) : super(key: key);

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My favorites"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.3.sm),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(
                    () => productController.products.isNotEmpty
                        ? Column(
                            children: productController.products
                                .map((e) => buildProductDismissible(e, context))
                                .toList(),
                          )
                        : SizedBox(
                      height: 0.5.sh,
                          child: Center(
                              child: Text(
                              "You have no favourites yet",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.sp),
                            )),
                        ),
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
              await showConfirmationDialog(context, "delete from favorite");
          await productController.deleteFavorite(product.id!);
          if (confirmation) {
            Helper.showSnackBack(context, "deleted from favorite",
                color: Colors.red);
          }
          return false;
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
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
        ));
  }

  Widget buildDismissibleSecondaryBackground(Product product) {
    return Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: primarycolor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
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
