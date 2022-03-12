import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/products/components/shop_short_details_card.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/widgets/search_field.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class ShopSearchResults extends StatelessWidget {
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
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.3.sm),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.sm),
                    child: SearchField(
                      onSubmit: (c) {},
                    ),
                  ),
                  Column(
                    children: products
                        .map((e) => ShopShortDetailCard(
                              product: e,
                              onPressed: () {
                                Get.to(() => ShopView());
                              },
                            ))
                        .toList(),
                  ),
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
