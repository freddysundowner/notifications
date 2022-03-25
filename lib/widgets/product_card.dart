import 'package:cached_network_image/cached_network_image.dart';
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
        width: 0.3.sw,
        margin: const EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: const BorderRadius.all(
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
          child: product.images!.isEmpty
              ? Image.asset(
                  imageplaceholder,
                  fit: BoxFit.contain,
                  height: 0.2.sh,
                  width: double.infinity,
                )
              : Center(
                child: CachedNetworkImage(
                    imageUrl: product.images![0],
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.infinity,
                      height: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fitWidth),
                      ),
                    ),
                    placeholder: (context, url) => const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 120,
                    ),
                  ),
              ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          product.htmlPrice(product.discountPrice).toString(),
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
