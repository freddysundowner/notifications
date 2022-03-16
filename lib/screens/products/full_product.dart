import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/products/components/custom_action_bar.dart';
import 'package:fluttergistshop/screens/products/components/product_size.dart';
import 'package:fluttergistshop/widgets/widgets.dart';

import '../../utils/utils.dart';

class FullProduct extends StatelessWidget {
  final Product product;
  FullProduct({required this.product});

  _addToCart() {}

  _addToSaved() {}

  final SnackBar _snackBar = SnackBar(
    content: Text("Product added to the cart"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(0),
            children: [
              ImageSwipe(
                imageList: product.images!,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 24.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 4.0,
                ),
                child: Text(
                  product.name!,
                  style: boldHeading,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 24.0,
                ),
                child: Text(
                  product.htmlPrice(product.price).toString(),
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 24.0,
                ),
                child: Text(
                  product.description.toString(),
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),
              ),
              if (product.variations!.length > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Variation",
                        style: regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: product.variations!,
                      onSelected: (size) {},
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _addToSaved();
                        Scaffold.of(context).showSnackBar(_snackBar);
                      },
                      child: Container(
                        width: 50.0.w,
                        height: 50.0.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFDCDCDC),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage(
                            "assets/images/tab_saved.png",
                          ),
                          height: 22.0.h,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await _addToCart();
                          Scaffold.of(context).showSnackBar(_snackBar);
                        },
                        child: Container(
                          height: 50.0.h,
                          margin: EdgeInsets.only(
                            left: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: primarycolor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Buy Now",
                            style: TextStyle(
                                fontSize: 18.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          CustomActionBar(
            title: 'nn',
            qty: product.quantity.toString(),
          )
        ],
      ),
    );
  }
}
