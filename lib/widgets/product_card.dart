import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/styles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final GestureTapCallback press;
  const ProductCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 150.w,
        margin: EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: buildProductCardItems(product),
      ),
    );
  }

  Column buildProductCardItems(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: product.images!.length == 0
              ? Image.asset(
                  imageplaceholder,
                  fit: BoxFit.contain,
                  height: 120,
                  width: double.infinity,
                )
              : Image.network(
                  product.images![0],
                  fit: BoxFit.fitWidth,
                  height: 120,
                  width: double.infinity,
                ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product.name}",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text.rich(
                TextSpan(
                  text: "${product.htmlPrice(product.price).toString()}\n",
                  style: TextStyle(
                    color: primarycolor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "${product.htmlPrice(product.discountPrice).toString()}",
                      style: TextStyle(
                        color: kTextColor,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.normal,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
