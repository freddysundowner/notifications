import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

class ShopSearchResults extends StatelessWidget {
  final ShopController _shopController = Get.find<ShopController>();

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  List<Product> products = getProducts();

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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.sm),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _shopController.searchShopController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Search Shops",
                          prefixIcon: const Icon(Icons.search),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 20.sm, vertical: 9.sm),
                        ),
                        onChanged: (c) => _shopController.searchShops(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                  Obx(() {
                    if (_shopController.searchedShops.isEmpty) {
                      _shopController.searchedShops.value = _shopController.allShops;
                    }
                    printOut(
                        "searched shops length ${_shopController.searchedShops.length}");
                    return _shopController.isSearchingShop.isFalse ? Column(
                      children: _shopController.searchedShops
                          .map((e) => InkWell(
                        onTap: () {
Get.to(ShopView(ShopId.fromJson(e)));
                        },
                            child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            NetworkImage(imageUrl + e["image"]),
                                      ),
                                      SizedBox(
                                        width: 0.04.sw,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e["name"],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp),
                                          ),
                                          Text(
                                              e["description"].toString().length >
                                                      40
                                                  ? e["description"]
                                                          .toString()
                                                          .substring(0, 40) +
                                                      "..."
                                                  : e["description"].toString(), style: TextStyle(color: Colors.grey, fontSize: 14.sp),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                          ))
                          .toList(),
                    ) : SizedBox(height: 0.5.sh,
                    child: const Center(child: CircularProgressIndicator(color: Colors.black,)),);
                  }),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ),
      ),
      //body: Body(),
    );
  }
}
