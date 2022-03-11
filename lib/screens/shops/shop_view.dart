import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/shops/add_edit_shop.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/utils.dart';

class ShopView extends StatelessWidget {
  final List<Product> products = getProducts();
  ShopView({Key? key}) : super(key: key);
  Future<void> refreshPage() {
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sm, vertical: 20.sm),
              decoration: BoxDecoration(color: primarycolor),
              child: Row(
                children: [
                  Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  "https://i.imgur.com/BoN9kdC.png")))),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fred Shop",
                          style:
                              TextStyle(fontSize: 21.sp, color: Colors.black),
                        ),
                        Text(
                          "description here",
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                        ),
                        Text("email here",
                            style:
                                TextStyle(fontSize: 13.sp, color: Colors.white))
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.to(() => NewShop());
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30.sm,
                    ),
                  )
                ],
              ),
            ),
            Text("Products", style: headingStyle),
            Column(
              children: products
                  .map((e) => buildProductDismissible(e, context))
                  .toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 4,
        hoverColor: Colors.green,
        splashColor: Colors.green,
        onPressed: () {},
        backgroundColor: Colors.pink,
      ),
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
            for (int i = 0; i < product.images.length; i++) {}

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
