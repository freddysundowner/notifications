import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/controllers/favorite_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/cart/checkout_screen.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:get/get.dart';

import '../../controllers/global.dart';
import '../../utils/utils.dart';

class Favorites extends StatelessWidget {
  CheckOutController checkOutController = Get.find<CheckOutController>();
  FavoriteController favproductController = Get.find<FavoriteController>();
  final RoomController _homeController = Get.find<RoomController>();
  final GlobalController _global = Get.find<GlobalController>();

  Favorites({Key? key}) : super(key: key);

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    _homeController.onChatPage.value = false;
    return WillPopScope(
      onWillPop: () async {
        _global.tabPosition.value = 0;
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "My favorites",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.3.sm),
                child: GetX<UserController>(
                  initState: (_) async {
                    favproductController.products.value =
                        await FavoriteController().getFavoriteProducts();
                  },
                  builder: (_) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          favproductController.products.length > 0
                              ? Column(
                                  children: favproductController.products
                                      .map((e) =>
                                          buildProductDismissible(e, context))
                                      .toList(),
                                )
                              : SizedBox(
                                  height: 0.5.sh,
                                  child: Center(
                                      child: Text(
                                    "You have no favourites yet",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16.sp),
                                  )),
                                ),
                          SizedBox(height: 0.02.sh),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )),
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

          if (confirmation) {
            await favproductController.deleteFavorite(product.id!);
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
